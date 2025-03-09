#!/bin/bash

export CUDA_VISIBLE_DEVICES=0,1
export NUM_GPUS=2

MODEL_PATH="Qwen/Qwen2.5-0.5B-Instruct"
OUTPUT_DIR="checkpoints"
TRAINING_SCRIPT="sft_ds_pipe.py"

PP_SIZE=2
DP_SIZE=$((NUM_GPUS/PP_SIZE))

mkdir -p $OUTPUT_DIR

echo "Training start: PP=$PP_SIZE, DP=$DP_SIZE, Total GPUs=$NUM_GPUS"

deepspeed \
    --num_gpus=$NUM_GPUS \
    $TRAINING_SCRIPT \
    --model_name_or_path $MODEL_PATH \
    --model_out_dir $OUTPUT_DIR \
    --pp_size $PP_SIZE \
    --per_device_train_batch_size 1 \
    --gradient_accumulation_steps 10 \
    --num_epochs 3 \
    --learning_rate 1e-5 \
    --max_seq_len 100 \
    --cutoff_len 100 \
    --fp16 \
    --checkpoint_activations \
    --checkpoint_num_layers 4 \
    --steps_per_print 1 \