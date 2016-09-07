typedef float* (*ActivityFunction)(float *);

static ActivityFunction *
activity_determine(int function_id, float alpha) {
  switch(function_id) {
    case  1: return arctan_pair();
    case  2: return bent_identity_pair();
    case  3: return gaussian_pair();
    case  4: return identity_pair();
    case  5: return logistic_pair();
    case  6: return relu_pair();
    case  7: return sinc_pair();
    case  8: return sinusoid_pair();
    case  9: return softmax_pair();
    case 10: return softplus_pair();
    case 11: return softsign_pair();
    case 12: return tanh_pair();
    case 13: return elu_pair(alpha);
    case 14: return prelu_pair(alpha);
  }
}
