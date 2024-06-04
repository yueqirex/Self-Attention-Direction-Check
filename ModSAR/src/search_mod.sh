# ===== tune =====
dataset_ls=(beauty sports yelp ml-1m video) # datasets
aspect=local_attn # loss_type_bce, loss_type_bpr, ssept
task_type=ae # ar
gpu=0 # $((gpu % 8))
for ((i=3;i<=3;i++)); do
    screen -dmS ${aspect}_${dataset_ls[i]}_${task_type} \
    bash -c "
            eval $(conda shell.bash hook); \
            conda activate lightning; \
            CUDA_VISIBLE_DEVICES=0,1 \
            python tune.py \
            --config configs/${aspect}/${dataset_ls[i]}_config_tune_${task_type}.yaml \
            -- \
            --config configs/${aspect}/${dataset_ls[i]}_config_run.yaml; \
            exec bash;
            "
    gpu=$((gpu + 1))
done



# ===== check errored trials =====
# bash -c "
#     eval $(conda shell.bash hook); \
#     conda activate lightning; \
#     python evaluation.py --results_dir=output_ray --mode=detect_error;
#     "



# ===== retrive best trial dir + export best config =====
# aspect_ls=("ssept" "loss_type_bce" "loss_type_bpr" "ssept")
# task_ls=("ae" "ar")
# ds_ls=("beauty" "sports" "yelp" "ml-1m" "video")
# for asp in "${aspect_ls[@]}"; do
#     for task in "${task_ls[@]}"; do
#         for ds in "${ds_ls[@]}"; do
#             bash -c "
#                 eval $(conda shell.bash hook); \
#                 conda activate lightning; \
#                 CUDA_VISIBLE_DEVICES=0 \
#                 python evaluation.py --mode=export_best_config --results_dir=output_ray --exp_name=${asp}_${task}_${ds} --device=gpu --seed=0;
#                 "
#         done
#     done
# done



# ===== rerun best config =====
# aspect_ls=("ssept" "loss_type_bce" "loss_type_bpr" "ssept")
# task_ls=("ae" "ar")
# ds_ls=("beauty" "sports" "yelp" "ml-1m" "video")
# i=0
# for asp in "${aspect_ls[@]}"; do
#     for task in "${task_ls[@]}"; do
#         for ds in "${ds_ls[@]}"; do
#             screen -dmS rerun_${asp}_${task}_${ds} \
#             bash -c "
#                 eval $(conda shell.bash hook); \
#                 conda activate lightning; \
#                 CUDA_VISIBLE_DEVICES=$((i % 3)) \
#                 python main.py fit --config output_ray/${asp}_${task}_${ds}/best_trial/best_config.yaml; \
#                 exec bash;
#                 "
#             i=$((i + 1))
#         done
#     done
# done



# ===== compare the best results for all =====
# bash -c "
#     eval $(conda shell.bash hook); \
#     conda activate lightning; \
#     python evaluation.py --results_dir=output_ray --exp_name=local_attn_ae_beauty --mode=val;
#     "
# python evaluation.py --results_dir=output_ray --mode=compare --with_config=False --succinct=True;



# ===== get run time =====
# bash -c "
#     eval $(conda shell.bash hook); \
#     conda activate lightning; \
#     python evaluation.py --results_dir=output_ray --mode=get_run_time;
#     "