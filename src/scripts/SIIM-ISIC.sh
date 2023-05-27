#!/bin/sh
#SBATCH --output=path/isic_inception_%j.out
pwd; hostname; date
CURRENT=`date +"%Y-%m-%d_%T"`
echo $CURRENT

slurm_output_bb_train=isic_inception_bb_train_$CURRENT.out
slurm_output_bb_test=isic_inception_bb_test_$CURRENT.out
slurm_output_t_train=isic_inception_t_train_$CURRENT.out
slurm_output_t_test=isic_inception_t_test_$CURRENT.out
slurm_output_iter1_g_train=isic_inception_iter1_g_train_$CURRENT.out
slurm_output_iter1_g_test=isic_inception_iter1_g_test_$CURRENT.out
slurm_output_iter1_residual_train=isic_inception_iter1_residual_train_$CURRENT.out
slurm_output_iter1_residual_test=isic_inception_iter1_residual_test_$CURRENT.out
slurm_output_iter2_g_train=isic_inception_iter2_g_train_$CURRENT.out
slurm_output_iter2_g_test=isic_inception_iter2_g_test_$CURRENT.out
slurm_output_iter2_residual_train=isic_inception_iter2_residual_train_$CURRENT.out
slurm_output_iter2_residual_test=isic_inception_iter2_residual_test_$CURRENT.out
slurm_output_iter3_g_train=isic_inception_iter3_g_train_$CURRENT.out
slurm_output_iter3_g_test=isic_inception_iter3_g_test_$CURRENT.out
slurm_output_iter3_residual_train=isic_inception_iter3_residual_train_$CURRENT.out
slurm_output_iter3_residual_test=isic_inception_iter3_residual_test_$CURRENT.out
slurm_output_iter4_g_train=isic_inception_iter4_g_train_$CURRENT.out
slurm_output_iter4_g_test=isic_inception_iter4_g_test_$CURRENT.out
slurm_output_iter4_residual_train=isic_inception_iter4_residual_train_$CURRENT.out
slurm_output_iter4_residual_test=isic_inception_iter4_residual_test_$CURRENT.out
slurm_output_iter5_g_train=isic_inception_iter5_g_train_$CURRENT.out
slurm_output_iter5_g_test=isic_inception_iter5_g_test_$CURRENT.out
slurm_output_iter5_residual_train=isic_inception_iter5_residual_train_$CURRENT.out
slurm_output_iter5_residual_test=isic_inception_iter5_residual_test_$CURRENT.out
slurm_output_iter6_g_train=isic_inception_iter6_g_train_$CURRENT.out
slurm_output_iter6_g_test=isic_inception_iter6_g_test_$CURRENT.out
slurm_output_iter6_residual_train=isic_inception_iter6_residual_train_$CURRENT.out
slurm_output_iter6_residual_test=isic_inception_iter6_residual_test_$CURRENT.out
slurm_explanations=isic_inception_explanations_$CURRENT.out

echo "SIIM-ISIC Inception_V3"
source path-of-conda/anaconda3/etc/profile.d/conda.sh
conda activate python_3_7_rtx_6000


#################################################
# Instructions for downloading the BB model
# Get the BB model from the Posthoc Concept Bottleneck repo (https://github.com/mertyg/post-hoc-cbm)
# or Get the checkpoints directly from https://drive.google.com/drive/folders/1WscikgfyQWg1OTPem_JZ-8EjbCQ_FHxm
# Do not change the name ham10000.pth
#################################################


# MoIE Training scripts
#---------------------------------
# # iter 1
#---------------------------------
# Train explainer
python ../codebase/train_explainer_ISIC.py --iter 1 --expert-to-train "explainer" --dataset "SIIM-ISIC" --cov 0.2 --bs 32 --lr 0.01 --temperature-lens 0.7 --lambda-lens 0.0001 --alpha-KD 0.9 --temperature-KD 10 --hidden-nodes 10 --lm 64 --arch "Inception_V3" > $slurm_output_iter1_g_train

# Test explainer
python ../codebase/test_explainer_ISIC.py --iter 1 --checkpoint-model "model_g_best_model_epoch_20.pth.tar" --expert-to-train "explainer" --dataset "SIIM-ISIC" --cov 0.2 --bs 32 --lr 0.01 --temperature-lens 0.7 --lambda-lens 0.0001 --alpha-KD 0.9 --temperature-KD 10 --hidden-nodes 10 --lm 64 --arch "Inception_V3" > $slurm_output_iter1_g_test

# Train residual
python ../codebase/train_explainer_ISIC.py --iter 1 --checkpoint-model "model_g_best_model_epoch_20.pth.tar" --expert-to-train "residual" --dataset "SIIM-ISIC" --cov 0.2 --bs 32 --lr 0.01 --temperature-lens 0.7 --lambda-lens 0.0001 --alpha-KD 0.9 --temperature-KD 10 --hidden-nodes 10 --lm 64 --arch "Inception_V3" > $slurm_output_iter1_residual_train

python ../codebase/test_explainer_ISIC.py --iter 1 --checkpoint-residual "model_residual_best_model_epoch_1.pth.tar" --checkpoint-model "model_g_best_model_epoch_20.pth.tar" --expert-to-train "residual" --dataset "SIIM-ISIC" --cov 0.2 --bs 32 --lr 0.01 --temperature-lens 0.7 --lambda-lens 0.0001 --alpha-KD 0.9 --temperature-KD 10 --hidden-nodes 10 --lm 64 --arch "Inception_V3" > $slurm_output_iter1_residual_test

#---------------------------------
# # iter 2
#---------------------------------
# Train explainer
python ../codebase/train_explainer_ISIC.py --iter 2 --prev_explainer_chk_pt_folder "../checkpoints/SIIM-ISIC/explainer/lr_0.01_epochs_500_temperature-lens_0.7_input-size-pi_2048_cov_0.2_alpha_0.5_selection-threshold_0.5_lambda-lens_0.0001_alpha-KD_0.9_temperature-KD_10.0_hidden-layers_1/iter1/" --checkpoint-model "model_g_best_model_epoch_20.pth.tar" --checkpoint-residual "model_residual_best_model_epoch_1.pth.tar" --expert-to-train "explainer" --dataset "SIIM-ISIC" --cov 0.2 0.2 --bs 32 --lr 0.01 0.01 --temperature-lens 0.7 --lambda-lens 0.0001 --alpha-KD 0.9 --temperature-KD 10 --hidden-nodes 10 --lm 64 --arch "Inception_V3" > $slurm_output_iter2_g_train

# Test explainer
python ../codebase/test_explainer_ISIC.py --iter 2 --prev_explainer_chk_pt_folder "../checkpoints/SIIM-ISIC/explainer/lr_0.01_epochs_500_temperature-lens_0.7_input-size-pi_2048_cov_0.2_alpha_0.5_selection-threshold_0.5_lambda-lens_0.0001_alpha-KD_0.9_temperature-KD_10.0_hidden-layers_1/iter1" --checkpoint-model "model_g_best_model_epoch_20.pth.tar" "model_g_best_model_epoch_18.pth.tar" --checkpoint-residual "model_residual_best_model_epoch_1.pth.tar" --expert-to-train "explainer" --dataset "SIIM-ISIC" --cov 0.2 0.2 --bs 32 --lr 0.01 0.01 --temperature-lens 0.7 --lambda-lens 0.0001 --alpha-KD 0.9 --temperature-KD 10 --hidden-nodes 10 --lm 64 --arch "Inception_V3" > $slurm_output_iter2_g_test

python ../codebase/train_explainer_ISIC.py --iter 2 --prev_explainer_chk_pt_folder "../checkpoints/SIIM-ISIC/explainer/lr_0.01_epochs_500_temperature-lens_0.7_input-size-pi_2048_cov_0.2_alpha_0.5_selection-threshold_0.5_lambda-lens_0.0001_alpha-KD_0.9_temperature-KD_10.0_hidden-layers_1/iter1" --checkpoint-model "model_g_best_model_epoch_20.pth.tar" "model_g_best_model_epoch_18.pth.tar" --checkpoint-residual "model_residual_best_model_epoch_1.pth.tar" --expert-to-train "residual" --dataset "SIIM-ISIC" --cov 0.2 0.2 --bs 32 --lr 0.01 0.01 --temperature-lens 0.7 --lambda-lens 0.0001 --alpha-KD 0.9 --temperature-KD 10 --hidden-nodes 10 --lm 64 --arch "Inception_V3" > $slurm_output_iter2_residual_train

python ../codebase/test_explainer_ISIC.py --iter 2 --prev_explainer_chk_pt_folder "../checkpoints/SIIM-ISIC/explainer/lr_0.01_epochs_500_temperature-lens_0.7_input-size-pi_2048_cov_0.2_alpha_0.5_selection-threshold_0.5_lambda-lens_0.0001_alpha-KD_0.9_temperature-KD_10.0_hidden-layers_1/iter1" --checkpoint-model "model_g_best_model_epoch_20.pth.tar" "model_g_best_model_epoch_18.pth.tar" --checkpoint-residual "model_residual_best_model_epoch_1.pth.tar" "model_residual_best_model_epoch_1.pth.tar" --expert-to-train "residual" --dataset "SIIM-ISIC" --cov 0.2 0.2 --bs 32 --lr 0.01 0.01 --temperature-lens 0.7 --lambda-lens 0.0001 --alpha-KD 0.9 --temperature-KD 10 --hidden-nodes 10 --lm 64 --arch "Inception_V3" > $slurm_output_iter2_residual_test

#---------------------------------
# # iter 3
#---------------------------------
# Train explainer
python ../codebase/train_explainer_ISIC.py --iter 3 --prev_explainer_chk_pt_folder "../checkpoints/SIIM-ISIC/explainer/lr_0.01_epochs_500_temperature-lens_0.7_input-size-pi_2048_cov_0.2_alpha_0.5_selection-threshold_0.5_lambda-lens_0.0001_alpha-KD_0.9_temperature-KD_10.0_hidden-layers_1/iter1" "../checkpoints/SIIM-ISIC/explainer/lr_0.01_epochs_500_temperature-lens_0.7_input-size-pi_2048_cov_0.2_alpha_0.5_selection-threshold_0.5_lambda-lens_0.0001_alpha-KD_0.9_temperature-KD_10.0_hidden-layers_1/cov_0.2/iter2" --checkpoint-model "model_g_best_model_epoch_20.pth.tar" "model_g_best_model_epoch_18.pth.tar" --checkpoint-residual "model_residual_best_model_epoch_1.pth.tar" "model_residual_best_model_epoch_1.pth.tar"  --expert-to-train "explainer" --dataset "SIIM-ISIC" --cov 0.2 0.2 0.2 --bs 32 --lr 0.01 0.01 0.01 --temperature-lens 0.7 --lambda-lens 0.0001 --alpha-KD 0.9 --temperature-KD 10 --hidden-nodes 10 --lm 64 --arch "Inception_V3" > $slurm_output_iter3_g_train

# Test explainer
python ../codebase/test_explainer_ISIC.py --iter 3 --prev_explainer_chk_pt_folder "../checkpoints/SIIM-ISIC/explainer/lr_0.01_epochs_500_temperature-lens_0.7_input-size-pi_2048_cov_0.2_alpha_0.5_selection-threshold_0.5_lambda-lens_0.0001_alpha-KD_0.9_temperature-KD_10.0_hidden-layers_1/iter1" "../checkpoints/SIIM-ISIC/explainer/lr_0.01_epochs_500_temperature-lens_0.7_input-size-pi_2048_cov_0.2_alpha_0.5_selection-threshold_0.5_lambda-lens_0.0001_alpha-KD_0.9_temperature-KD_10.0_hidden-layers_1/cov_0.2/iter2" --checkpoint-model "model_g_best_model_epoch_20.pth.tar" "model_g_best_model_epoch_18.pth.tar" "model_g_best_model_epoch_9.pth.tar" --checkpoint-residual "model_residual_best_model_epoch_1.pth.tar" "model_residual_best_model_epoch_1.pth.tar"  --expert-to-train "explainer" --dataset "SIIM-ISIC" --cov 0.2 0.2 0.2 --bs 32 --lr 0.01 0.01 0.01 --temperature-lens 0.7 --lambda-lens 0.0001 --alpha-KD 0.9 --temperature-KD 10 --hidden-nodes 10 --lm 64 --arch "Inception_V3" > $slurm_output_iter3_g_test

# Train residual
python ../codebase/train_explainer_ISIC.py --iter 3 --prev_explainer_chk_pt_folder "../checkpoints/SIIM-ISIC/explainer/lr_0.01_epochs_500_temperature-lens_0.7_input-size-pi_2048_cov_0.2_alpha_0.5_selection-threshold_0.5_lambda-lens_0.0001_alpha-KD_0.9_temperature-KD_10.0_hidden-layers_1/iter1" "../checkpoints/SIIM-ISIC/explainer/lr_0.01_epochs_500_temperature-lens_0.7_input-size-pi_2048_cov_0.2_alpha_0.5_selection-threshold_0.5_lambda-lens_0.0001_alpha-KD_0.9_temperature-KD_10.0_hidden-layers_1/cov_0.2/iter2" --checkpoint-model "model_g_best_model_epoch_20.pth.tar" "model_g_best_model_epoch_18.pth.tar" "model_g_best_model_epoch_9.pth.tar" --checkpoint-residual "model_residual_best_model_epoch_1.pth.tar" "model_residual_best_model_epoch_1.pth.tar"  --expert-to-train "residual" --dataset "SIIM-ISIC" --cov 0.2 0.2 0.2 --bs 32 --lr 0.01 0.01 0.01 --temperature-lens 0.7 --lambda-lens 0.0001 --alpha-KD 0.9 --temperature-KD 10 --hidden-nodes 10 --lm 64 --arch "Inception_V3" > $slurm_output_iter3_residual_train

python ../codebase/test_explainer_ISIC.py --iter 3 --prev_explainer_chk_pt_folder "../checkpoints/SIIM-ISIC/explainer/lr_0.01_epochs_500_temperature-lens_0.7_input-size-pi_2048_cov_0.2_alpha_0.5_selection-threshold_0.5_lambda-lens_0.0001_alpha-KD_0.9_temperature-KD_10.0_hidden-layers_1/iter1" "../checkpoints/SIIM-ISIC/explainer/lr_0.01_epochs_500_temperature-lens_0.7_input-size-pi_2048_cov_0.2_alpha_0.5_selection-threshold_0.5_lambda-lens_0.0001_alpha-KD_0.9_temperature-KD_10.0_hidden-layers_1/cov_0.2/iter2" --checkpoint-model "model_g_best_model_epoch_20.pth.tar" "model_g_best_model_epoch_18.pth.tar" "model_g_best_model_epoch_9.pth.tar" --checkpoint-residual "model_residual_best_model_epoch_1.pth.tar" "model_residual_best_model_epoch_1.pth.tar"  "model_residual_best_model_epoch_3.pth.tar" --expert-to-train "residual" --dataset "SIIM-ISIC" --cov 0.2 0.2 0.2 --bs 32 --lr 0.01 0.01 0.01 --temperature-lens 0.7 --lambda-lens 0.0001 --alpha-KD 0.9 --temperature-KD 10 --hidden-nodes 10 --lm 64 --arch "Inception_V3" > $slurm_output_iter3_residual_test

#---------------------------------
# # iter 4
#---------------------------------
# Train explainer
python ../codebase/train_explainer_ISIC.py --iter 4 --prev_explainer_chk_pt_folder "../checkpoints/SIIM-ISIC/explainer/lr_0.01_epochs_500_temperature-lens_0.7_input-size-pi_2048_cov_0.2_alpha_0.5_selection-threshold_0.5_lambda-lens_0.0001_alpha-KD_0.9_temperature-KD_10.0_hidden-layers_1/iter1" "../checkpoints/SIIM-ISIC/explainer/lr_0.01_epochs_500_temperature-lens_0.7_input-size-pi_2048_cov_0.2_alpha_0.5_selection-threshold_0.5_lambda-lens_0.0001_alpha-KD_0.9_temperature-KD_10.0_hidden-layers_1/cov_0.2/iter2" "../checkpoints/SIIM-ISIC/explainer/lr_0.01_epochs_500_temperature-lens_0.7_input-size-pi_2048_cov_0.2_alpha_0.5_selection-threshold_0.5_lambda-lens_0.0001_alpha-KD_0.9_temperature-KD_10.0_hidden-layers_1/cov_0.2/iter3" --checkpoint-model "model_g_best_model_epoch_20.pth.tar" "model_g_best_model_epoch_18.pth.tar" "model_g_best_model_epoch_9.pth.tar" --checkpoint-residual "model_residual_best_model_epoch_1.pth.tar" "model_residual_best_model_epoch_1.pth.tar"  "model_residual_best_model_epoch_3.pth.tar" --expert-to-train "explainer" --dataset "SIIM-ISIC" --cov 0.2 0.2 0.2 0.2 --bs 32 --lr 0.01 0.01 0.01 0.01 --temperature-lens 0.7 --lambda-lens 0.0001 --alpha-KD 0.9 --temperature-KD 10 --hidden-nodes 10 --lm 64 --arch "Inception_V3" > $slurm_output_iter4_g_train

# Test explainer
python ../codebase/test_explainer_ISIC.py --iter 4 --prev_explainer_chk_pt_folder "../checkpoints/SIIM-ISIC/explainer/lr_0.01_epochs_500_temperature-lens_0.7_input-size-pi_2048_cov_0.2_alpha_0.5_selection-threshold_0.5_lambda-lens_0.0001_alpha-KD_0.9_temperature-KD_10.0_hidden-layers_1/iter1" "../checkpoints/SIIM-ISIC/explainer/lr_0.01_epochs_500_temperature-lens_0.7_input-size-pi_2048_cov_0.2_alpha_0.5_selection-threshold_0.5_lambda-lens_0.0001_alpha-KD_0.9_temperature-KD_10.0_hidden-layers_1/cov_0.2/iter2" "../checkpoints/SIIM-ISIC/explainer/lr_0.01_epochs_500_temperature-lens_0.7_input-size-pi_2048_cov_0.2_alpha_0.5_selection-threshold_0.5_lambda-lens_0.0001_alpha-KD_0.9_temperature-KD_10.0_hidden-layers_1/cov_0.2/iter3" --checkpoint-model "model_g_best_model_epoch_20.pth.tar" "model_g_best_model_epoch_18.pth.tar" "model_g_best_model_epoch_9.pth.tar" "model_g_best_model_epoch_21.pth.tar" --checkpoint-residual "model_residual_best_model_epoch_1.pth.tar" "model_residual_best_model_epoch_1.pth.tar" "model_residual_best_model_epoch_3.pth.tar"  --expert-to-train "explainer" --dataset "SIIM-ISIC" --cov 0.2 0.2 0.2 0.2 --bs 32 --lr 0.01 0.01 0.01 0.01 --temperature-lens 0.7 --lambda-lens 0.0001 --alpha-KD 0.9 --temperature-KD 10 --hidden-nodes 10 --lm 64 --arch "Inception_V3" > $slurm_output_iter4_g_test

# Train residual
python ../codebase/train_explainer_ISIC.py --iter 4 --prev_explainer_chk_pt_folder "../checkpoints/SIIM-ISIC/explainer/lr_0.01_epochs_500_temperature-lens_0.7_input-size-pi_2048_cov_0.2_alpha_0.5_selection-threshold_0.5_lambda-lens_0.0001_alpha-KD_0.9_temperature-KD_10.0_hidden-layers_1/iter1" "../checkpoints/SIIM-ISIC/explainer/lr_0.01_epochs_500_temperature-lens_0.7_input-size-pi_2048_cov_0.2_alpha_0.5_selection-threshold_0.5_lambda-lens_0.0001_alpha-KD_0.9_temperature-KD_10.0_hidden-layers_1/cov_0.2/iter2" "../checkpoints/SIIM-ISIC/explainer/lr_0.01_epochs_500_temperature-lens_0.7_input-size-pi_2048_cov_0.2_alpha_0.5_selection-threshold_0.5_lambda-lens_0.0001_alpha-KD_0.9_temperature-KD_10.0_hidden-layers_1/cov_0.2/iter3" --checkpoint-model "model_g_best_model_epoch_20.pth.tar" "model_g_best_model_epoch_18.pth.tar" "model_g_best_model_epoch_9.pth.tar" "model_g_best_model_epoch_21.pth.tar" --checkpoint-residual "model_residual_best_model_epoch_1.pth.tar" "model_residual_best_model_epoch_1.pth.tar" "model_residual_best_model_epoch_3.pth.tar" --expert-to-train "residual" --dataset "SIIM-ISIC" --cov 0.2 0.2 0.2 0.2 --bs 32 --lr 0.01 0.01 0.01 0.01 --temperature-lens 0.7 --lambda-lens 0.0001 --alpha-KD 0.9 --temperature-KD 10 --hidden-nodes 10 --lm 64 --arch "Inception_V3" > $slurm_output_iter4_residual_train

python ../codebase/test_explainer_ISIC.py --iter 4 --prev_explainer_chk_pt_folder "../checkpoints/SIIM-ISIC/explainer/lr_0.01_epochs_500_temperature-lens_0.7_input-size-pi_2048_cov_0.2_alpha_0.5_selection-threshold_0.5_lambda-lens_0.0001_alpha-KD_0.9_temperature-KD_10.0_hidden-layers_1/iter1" "../checkpoints/SIIM-ISIC/explainer/lr_0.01_epochs_500_temperature-lens_0.7_input-size-pi_2048_cov_0.2_alpha_0.5_selection-threshold_0.5_lambda-lens_0.0001_alpha-KD_0.9_temperature-KD_10.0_hidden-layers_1/cov_0.2/iter2" "../checkpoints/SIIM-ISIC/explainer/lr_0.01_epochs_500_temperature-lens_0.7_input-size-pi_2048_cov_0.2_alpha_0.5_selection-threshold_0.5_lambda-lens_0.0001_alpha-KD_0.9_temperature-KD_10.0_hidden-layers_1/cov_0.2/iter3" --checkpoint-model "model_g_best_model_epoch_20.pth.tar" "model_g_best_model_epoch_18.pth.tar" "model_g_best_model_epoch_9.pth.tar" "model_g_best_model_epoch_21.pth.tar" --checkpoint-residual "model_residual_best_model_epoch_1.pth.tar" "model_residual_best_model_epoch_1.pth.tar" "model_residual_best_model_epoch_3.pth.tar" "model_residual_best_model_epoch_3.pth.tar" --expert-to-train "residual" --dataset "SIIM-ISIC" --cov 0.2 0.2 0.2 0.2 --bs 32 --lr 0.01 0.01 0.01 0.01 --temperature-lens 0.7 --lambda-lens 0.0001 --alpha-KD 0.9 --temperature-KD 10 --hidden-nodes 10 --lm 64 --arch "Inception_V3" > $slurm_output_iter4_residual_test

#---------------------------------
# # iter 5
#---------------------------------
# Train explainer
python ../codebase/train_explainer_ISIC.py --iter 5  --prev_explainer_chk_pt_folder "../checkpoints/SIIM-ISIC/explainer/lr_0.01_epochs_500_temperature-lens_0.7_input-size-pi_2048_cov_0.2_alpha_0.5_selection-threshold_0.5_lambda-lens_0.0001_alpha-KD_0.9_temperature-KD_10.0_hidden-layers_1/iter1" "../checkpoints/SIIM-ISIC/explainer/lr_0.01_epochs_500_temperature-lens_0.7_input-size-pi_2048_cov_0.2_alpha_0.5_selection-threshold_0.5_lambda-lens_0.0001_alpha-KD_0.9_temperature-KD_10.0_hidden-layers_1/cov_0.2/iter2" "../checkpoints/SIIM-ISIC/explainer/lr_0.01_epochs_500_temperature-lens_0.7_input-size-pi_2048_cov_0.2_alpha_0.5_selection-threshold_0.5_lambda-lens_0.0001_alpha-KD_0.9_temperature-KD_10.0_hidden-layers_1/cov_0.2/iter3" "../checkpoints/SIIM-ISIC/explainer/lr_0.01_epochs_500_temperature-lens_0.7_input-size-pi_2048_cov_0.2_alpha_0.5_selection-threshold_0.5_lambda-lens_0.0001_alpha-KD_0.9_temperature-KD_10.0_hidden-layers_1/cov_0.2/iter4" --checkpoint-model "model_g_best_model_epoch_20.pth.tar" "model_g_best_model_epoch_18.pth.tar" "model_g_best_model_epoch_9.pth.tar" "model_g_best_model_epoch_21.pth.tar" --checkpoint-residual "model_residual_best_model_epoch_1.pth.tar" "model_residual_best_model_epoch_1.pth.tar" "model_residual_best_model_epoch_3.pth.tar" "model_residual_best_model_epoch_3.pth.tar" --expert-to-train "explainer" --dataset "SIIM-ISIC" --cov 0.2 0.2 0.2 0.2 0.2 --bs 32 --lr 0.01 0.01 0.01 0.01 0.01 --temperature-lens 0.7 --lambda-lens 0.0001 --alpha-KD 0.9 --temperature-KD 10 --hidden-nodes 10 --lm 64 --arch "Inception_V3" > $slurm_output_iter5_g_train

# Test explainer
python ../codebase/test_explainer_ISIC.py --iter 5 --prev_explainer_chk_pt_folder "../checkpoints/SIIM-ISIC/explainer/lr_0.01_epochs_500_temperature-lens_0.7_input-size-pi_2048_cov_0.2_alpha_0.5_selection-threshold_0.5_lambda-lens_0.0001_alpha-KD_0.9_temperature-KD_10.0_hidden-layers_1/iter1" "../checkpoints/SIIM-ISIC/explainer/lr_0.01_epochs_500_temperature-lens_0.7_input-size-pi_2048_cov_0.2_alpha_0.5_selection-threshold_0.5_lambda-lens_0.0001_alpha-KD_0.9_temperature-KD_10.0_hidden-layers_1/cov_0.2/iter2" "../checkpoints/SIIM-ISIC/explainer/lr_0.01_epochs_500_temperature-lens_0.7_input-size-pi_2048_cov_0.2_alpha_0.5_selection-threshold_0.5_lambda-lens_0.0001_alpha-KD_0.9_temperature-KD_10.0_hidden-layers_1/cov_0.2/iter3" "../checkpoints/SIIM-ISIC/explainer/lr_0.01_epochs_500_temperature-lens_0.7_input-size-pi_2048_cov_0.2_alpha_0.5_selection-threshold_0.5_lambda-lens_0.0001_alpha-KD_0.9_temperature-KD_10.0_hidden-layers_1/cov_0.2/iter4" --checkpoint-model "model_g_best_model_epoch_20.pth.tar" "model_g_best_model_epoch_18.pth.tar" "model_g_best_model_epoch_9.pth.tar" "model_g_best_model_epoch_21.pth.tar" "model_g_best_model_epoch_19.pth.tar" --checkpoint-residual "model_residual_best_model_epoch_1.pth.tar" "model_residual_best_model_epoch_1.pth.tar" "model_residual_best_model_epoch_3.pth.tar" "model_residual_best_model_epoch_3.pth.tar" --expert-to-train "explainer" --dataset "SIIM-ISIC" --cov 0.2 0.2 0.2 0.2 0.2 --bs 32 --lr 0.01 0.01 0.01 0.01 0.01 --temperature-lens 0.7 --lambda-lens 0.0001 --alpha-KD 0.9 --temperature-KD 10 --hidden-nodes 10 --arch "Inception_V3" > $slurm_output_iter5_g_test

# Train residual
python ../codebase/train_explainer_ISIC.py --iter 5 --prev_explainer_chk_pt_folder "../checkpoints/SIIM-ISIC/explainer/lr_0.01_epochs_500_temperature-lens_0.7_input-size-pi_2048_cov_0.2_alpha_0.5_selection-threshold_0.5_lambda-lens_0.0001_alpha-KD_0.9_temperature-KD_10.0_hidden-layers_1/iter1" "../checkpoints/SIIM-ISIC/explainer/lr_0.01_epochs_500_temperature-lens_0.7_input-size-pi_2048_cov_0.2_alpha_0.5_selection-threshold_0.5_lambda-lens_0.0001_alpha-KD_0.9_temperature-KD_10.0_hidden-layers_1/cov_0.2/iter2" "../checkpoints/SIIM-ISIC/explainer/lr_0.01_epochs_500_temperature-lens_0.7_input-size-pi_2048_cov_0.2_alpha_0.5_selection-threshold_0.5_lambda-lens_0.0001_alpha-KD_0.9_temperature-KD_10.0_hidden-layers_1/cov_0.2/iter3" "../checkpoints/SIIM-ISIC/explainer/lr_0.01_epochs_500_temperature-lens_0.7_input-size-pi_2048_cov_0.2_alpha_0.5_selection-threshold_0.5_lambda-lens_0.0001_alpha-KD_0.9_temperature-KD_10.0_hidden-layers_1/cov_0.2/iter4" --checkpoint-model "model_g_best_model_epoch_20.pth.tar" "model_g_best_model_epoch_18.pth.tar" "model_g_best_model_epoch_9.pth.tar" "model_g_best_model_epoch_21.pth.tar" "model_g_best_model_epoch_19.pth.tar" --checkpoint-residual "model_residual_best_model_epoch_1.pth.tar" "model_residual_best_model_epoch_1.pth.tar" "model_residual_best_model_epoch_3.pth.tar" "model_residual_best_model_epoch_3.pth.tar" --expert-to-train "residual" --dataset "SIIM-ISIC" --cov 0.2 0.2 0.2 0.2 0.2 --bs 32 --lr 0.01 0.01 0.01 0.01 0.01 --temperature-lens 0.7 --lambda-lens 0.0001 --alpha-KD 0.9 --temperature-KD 10 --hidden-nodes 10 --arch "Inception_V3" > $slurm_output_iter5_residual_train

python ../codebase/test_explainer_ISIC.py --iter 5 --prev_explainer_chk_pt_folder "../checkpoints/SIIM-ISIC/explainer/lr_0.01_epochs_500_temperature-lens_0.7_input-size-pi_2048_cov_0.2_alpha_0.5_selection-threshold_0.5_lambda-lens_0.0001_alpha-KD_0.9_temperature-KD_10.0_hidden-layers_1/iter1" "../checkpoints/SIIM-ISIC/explainer/lr_0.01_epochs_500_temperature-lens_0.7_input-size-pi_2048_cov_0.2_alpha_0.5_selection-threshold_0.5_lambda-lens_0.0001_alpha-KD_0.9_temperature-KD_10.0_hidden-layers_1/cov_0.2/iter2" "../checkpoints/SIIM-ISIC/explainer/lr_0.01_epochs_500_temperature-lens_0.7_input-size-pi_2048_cov_0.2_alpha_0.5_selection-threshold_0.5_lambda-lens_0.0001_alpha-KD_0.9_temperature-KD_10.0_hidden-layers_1/cov_0.2/iter3" "../checkpoints/SIIM-ISIC/explainer/lr_0.01_epochs_500_temperature-lens_0.7_input-size-pi_2048_cov_0.2_alpha_0.5_selection-threshold_0.5_lambda-lens_0.0001_alpha-KD_0.9_temperature-KD_10.0_hidden-layers_1/cov_0.2/iter4" --checkpoint-model "model_g_best_model_epoch_20.pth.tar" "model_g_best_model_epoch_18.pth.tar" "model_g_best_model_epoch_9.pth.tar" "model_g_best_model_epoch_21.pth.tar" "model_g_best_model_epoch_19.pth.tar" --checkpoint-residual "model_residual_best_model_epoch_1.pth.tar" "model_residual_best_model_epoch_1.pth.tar" "model_residual_best_model_epoch_3.pth.tar" "model_residual_best_model_epoch_3.pth.tar" "model_residual_best_model_epoch_1.pth.tar" --expert-to-train "residual" --dataset "SIIM-ISIC" --cov 0.2 0.2 0.2 0.2 0.2 --bs 32 --lr 0.01 0.01 0.01 0.01 0.01 --temperature-lens 0.7 --lambda-lens 0.0001 --alpha-KD 0.9 --temperature-KD 10 --hidden-nodes 10 --arch "Inception_V3" > $slurm_output_iter5_residual_test



#---------------------------------
# # iter 6
#---------------------------------
# Train explainer
python ../codebase/train_explainer_ISIC.py --iter 6  --prev_explainer_chk_pt_folder "../checkpoints/SIIM-ISIC/explainer/lr_0.01_epochs_500_temperature-lens_0.7_input-size-pi_2048_cov_0.2_alpha_0.5_selection-threshold_0.5_lambda-lens_0.0001_alpha-KD_0.9_temperature-KD_10.0_hidden-layers_1/iter1" "../checkpoints/SIIM-ISIC/explainer/lr_0.01_epochs_500_temperature-lens_0.7_input-size-pi_2048_cov_0.2_alpha_0.5_selection-threshold_0.5_lambda-lens_0.0001_alpha-KD_0.9_temperature-KD_10.0_hidden-layers_1/cov_0.2/iter2" "../checkpoints/SIIM-ISIC/explainer/lr_0.01_epochs_500_temperature-lens_0.7_input-size-pi_2048_cov_0.2_alpha_0.5_selection-threshold_0.5_lambda-lens_0.0001_alpha-KD_0.9_temperature-KD_10.0_hidden-layers_1/cov_0.2/iter3" "../checkpoints/SIIM-ISIC/explainer/lr_0.01_epochs_500_temperature-lens_0.7_input-size-pi_2048_cov_0.2_alpha_0.5_selection-threshold_0.5_lambda-lens_0.0001_alpha-KD_0.9_temperature-KD_10.0_hidden-layers_1/cov_0.2/iter4" "../checkpoints/SIIM-ISIC/explainer/lr_0.01_epochs_500_temperature-lens_0.7_input-size-pi_2048_cov_0.2_alpha_0.5_selection-threshold_0.5_lambda-lens_0.0001_alpha-KD_0.9_temperature-KD_10.0_hidden-layers_1/cov_0.2/iter5" --checkpoint-model "model_g_best_model_epoch_20.pth.tar" "model_g_best_model_epoch_18.pth.tar" "model_g_best_model_epoch_9.pth.tar" "model_g_best_model_epoch_21.pth.tar" "model_g_best_model_epoch_19.pth.tar" --checkpoint-residual "model_residual_best_model_epoch_1.pth.tar" "model_residual_best_model_epoch_1.pth.tar" "model_residual_best_model_epoch_3.pth.tar" "model_residual_best_model_epoch_3.pth.tar" "model_residual_best_model_epoch_1.pth.tar" --expert-to-train "explainer" --dataset "SIIM-ISIC" --cov 0.2 0.2 0.2 0.2 0.2 0.2 --bs 32 --lr 0.01 0.01 0.01 0.01 0.01 0.01 --temperature-lens 0.7 --lambda-lens 0.0001 --alpha-KD 0.9 --temperature-KD 10 --hidden-nodes 10 --lm 64 --arch "Inception_V3" > $slurm_output_iter6_g_train

# Test explainer
python ../codebase/test_explainer_ISIC.py --iter 6 --prev_explainer_chk_pt_folder "../checkpoints/SIIM-ISIC/explainer/lr_0.01_epochs_500_temperature-lens_0.7_input-size-pi_2048_cov_0.2_alpha_0.5_selection-threshold_0.5_lambda-lens_0.0001_alpha-KD_0.9_temperature-KD_10.0_hidden-layers_1/iter1" "../checkpoints/SIIM-ISIC/explainer/lr_0.01_epochs_500_temperature-lens_0.7_input-size-pi_2048_cov_0.2_alpha_0.5_selection-threshold_0.5_lambda-lens_0.0001_alpha-KD_0.9_temperature-KD_10.0_hidden-layers_1/cov_0.2/iter2" "../checkpoints/SIIM-ISIC/explainer/lr_0.01_epochs_500_temperature-lens_0.7_input-size-pi_2048_cov_0.2_alpha_0.5_selection-threshold_0.5_lambda-lens_0.0001_alpha-KD_0.9_temperature-KD_10.0_hidden-layers_1/cov_0.2/iter3" "../checkpoints/SIIM-ISIC/explainer/lr_0.01_epochs_500_temperature-lens_0.7_input-size-pi_2048_cov_0.2_alpha_0.5_selection-threshold_0.5_lambda-lens_0.0001_alpha-KD_0.9_temperature-KD_10.0_hidden-layers_1/cov_0.2/iter4" "../checkpoints/SIIM-ISIC/explainer/lr_0.01_epochs_500_temperature-lens_0.7_input-size-pi_2048_cov_0.2_alpha_0.5_selection-threshold_0.5_lambda-lens_0.0001_alpha-KD_0.9_temperature-KD_10.0_hidden-layers_1/cov_0.2/iter5" --checkpoint-model "model_g_best_model_epoch_20.pth.tar" "model_g_best_model_epoch_18.pth.tar" "model_g_best_model_epoch_9.pth.tar" "model_g_best_model_epoch_21.pth.tar" "model_g_best_model_epoch_19.pth.tar" "model_g_best_model_epoch_1.pth.tar" --checkpoint-residual "model_residual_best_model_epoch_1.pth.tar" "model_residual_best_model_epoch_1.pth.tar" "model_residual_best_model_epoch_3.pth.tar" "model_residual_best_model_epoch_3.pth.tar" "model_residual_best_model_epoch_1.pth.tar" --expert-to-train "explainer" --dataset "SIIM-ISIC" --cov 0.2 0.2 0.2 0.2 0.2 0.2 --bs 32 --lr 0.01 0.01 0.01 0.01 0.01 0.01 --temperature-lens 0.7 --lambda-lens 0.0001 --alpha-KD 0.9 --temperature-KD 10 --hidden-nodes 10 --arch "Inception_V3" > $slurm_output_iter6_g_test

# Train residual
python ../codebase/train_explainer_ISIC.py --iter 6 --prev_explainer_chk_pt_folder "../checkpoints/SIIM-ISIC/explainer/lr_0.01_epochs_500_temperature-lens_0.7_input-size-pi_2048_cov_0.2_alpha_0.5_selection-threshold_0.5_lambda-lens_0.0001_alpha-KD_0.9_temperature-KD_10.0_hidden-layers_1/iter1" "../checkpoints/SIIM-ISIC/explainer/lr_0.01_epochs_500_temperature-lens_0.7_input-size-pi_2048_cov_0.2_alpha_0.5_selection-threshold_0.5_lambda-lens_0.0001_alpha-KD_0.9_temperature-KD_10.0_hidden-layers_1/cov_0.2/iter2" "../checkpoints/SIIM-ISIC/explainer/lr_0.01_epochs_500_temperature-lens_0.7_input-size-pi_2048_cov_0.2_alpha_0.5_selection-threshold_0.5_lambda-lens_0.0001_alpha-KD_0.9_temperature-KD_10.0_hidden-layers_1/cov_0.2/iter3" "../checkpoints/SIIM-ISIC/explainer/lr_0.01_epochs_500_temperature-lens_0.7_input-size-pi_2048_cov_0.2_alpha_0.5_selection-threshold_0.5_lambda-lens_0.0001_alpha-KD_0.9_temperature-KD_10.0_hidden-layers_1/cov_0.2/iter4" "../checkpoints/SIIM-ISIC/explainer/lr_0.01_epochs_500_temperature-lens_0.7_input-size-pi_2048_cov_0.2_alpha_0.5_selection-threshold_0.5_lambda-lens_0.0001_alpha-KD_0.9_temperature-KD_10.0_hidden-layers_1/cov_0.2/iter5" --checkpoint-model "model_g_best_model_epoch_20.pth.tar" "model_g_best_model_epoch_18.pth.tar" "model_g_best_model_epoch_9.pth.tar" "model_g_best_model_epoch_21.pth.tar" "model_g_best_model_epoch_19.pth.tar" "model_g_best_model_epoch_1.pth.tar" --checkpoint-residual "model_residual_best_model_epoch_1.pth.tar" "model_residual_best_model_epoch_1.pth.tar" "model_residual_best_model_epoch_3.pth.tar" "model_residual_best_model_epoch_3.pth.tar" "model_residual_best_model_epoch_1.pth.tar" --expert-to-train "residual" --dataset "SIIM-ISIC" --cov 0.2 0.2 0.2 0.2 0.2 0.2 --bs 32 --lr 0.01 0.01 0.01 0.01 0.01 0.01 --temperature-lens 0.7 --lambda-lens 0.0001 --alpha-KD 0.9 --temperature-KD 10 --hidden-nodes 10 --arch "Inception_V3" > $slurm_output_iter6_residual_train

python ../codebase/test_explainer_ISIC.py --iter 6 --prev_explainer_chk_pt_folder "../checkpoints/SIIM-ISIC/explainer/lr_0.01_epochs_500_temperature-lens_0.7_input-size-pi_2048_cov_0.2_alpha_0.5_selection-threshold_0.5_lambda-lens_0.0001_alpha-KD_0.9_temperature-KD_10.0_hidden-layers_1/iter1" "../checkpoints/SIIM-ISIC/explainer/lr_0.01_epochs_500_temperature-lens_0.7_input-size-pi_2048_cov_0.2_alpha_0.5_selection-threshold_0.5_lambda-lens_0.0001_alpha-KD_0.9_temperature-KD_10.0_hidden-layers_1/cov_0.2/iter2" "../checkpoints/SIIM-ISIC/explainer/lr_0.01_epochs_500_temperature-lens_0.7_input-size-pi_2048_cov_0.2_alpha_0.5_selection-threshold_0.5_lambda-lens_0.0001_alpha-KD_0.9_temperature-KD_10.0_hidden-layers_1/cov_0.2/iter3" "../checkpoints/SIIM-ISIC/explainer/lr_0.01_epochs_500_temperature-lens_0.7_input-size-pi_2048_cov_0.2_alpha_0.5_selection-threshold_0.5_lambda-lens_0.0001_alpha-KD_0.9_temperature-KD_10.0_hidden-layers_1/cov_0.2/iter4" "../checkpoints/SIIM-ISIC/explainer/lr_0.01_epochs_500_temperature-lens_0.7_input-size-pi_2048_cov_0.2_alpha_0.5_selection-threshold_0.5_lambda-lens_0.0001_alpha-KD_0.9_temperature-KD_10.0_hidden-layers_1/cov_0.2/iter5" --checkpoint-model "model_g_best_model_epoch_20.pth.tar" "model_g_best_model_epoch_18.pth.tar" "model_g_best_model_epoch_9.pth.tar" "model_g_best_model_epoch_21.pth.tar" "model_g_best_model_epoch_19.pth.tar" "model_g_best_model_epoch_1.pth.tar" --checkpoint-residual "model_residual_best_model_epoch_1.pth.tar" "model_residual_best_model_epoch_1.pth.tar" "model_residual_best_model_epoch_3.pth.tar" "model_residual_best_model_epoch_3.pth.tar" "model_residual_best_model_epoch_1.pth.tar" "model_residual_best_model_epoch_1.pth.tar" --expert-to-train "residual" --dataset ""SIIM-ISIC"" --cov 0.2 0.2 0.2 0.2 0.2 0.2 --bs 32 --lr 0.01 0.01 0.01 0.01 0.01 0.01 --temperature-lens 0.7 --lambda-lens 0.0001 --alpha-KD 0.9 --temperature-KD 10 --hidden-nodes 10 --arch "Inception_V3" > $slurm_output_iter6_residual_test


# # #---------------------------------
# # # # Explanations
# # #---------------------------------
# Update ./src/codebase/Completeness_and_interventions/paths_MoIE.json file with appropriate paths for the checkpoints and outputs
python ../codebase/FOLs_vision_main.py --arch "Inception_V3" --dataset "SIIM-ISIC" --iterations 6 > $slurm_explanations

