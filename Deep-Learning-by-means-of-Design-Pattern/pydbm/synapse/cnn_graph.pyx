# -*- coding: utf-8 -*-
import numpy as np
cimport numpy as np
cimport cython
from pydbm.synapse_list import Synapse
from pydbm.params_initializer import ParamsInitializer


class CNNGraph(Synapse):
    '''
    Computation graph in CNN.
    '''
    
    # Weight matrix (kernel)
    __weight_arr = None
    
    def get_weight_arr(self):
        ''' getter '''
        return self.__weight_arr

    def set_weight_arr(self, value):
        ''' setter '''
        self.__weight_arr = value
    
    weight_arr = property(get_weight_arr, set_weight_arr)

    # Bias vector.
    __bias_arr = None
    
    def get_bias_arr(self):
        ''' getter '''
        return self.__bias_arr

    def set_bias_arr(self, value):
        ''' setter '''
        self.__bias_arr = value
    
    bias_arr = property(get_bias_arr, set_bias_arr)

    # Activation function.
    __activation_function = None
    
    def get_activation_function(self):
        ''' getter '''
        return self.__activation_function
    
    def set_activation_function(self, value):
        ''' setter '''
        self.__activation_function = value
    
    activation_function = property(get_activation_function, set_activation_function)

    # Activation function for deconvolution.
    __deactivation_function = None
    
    def get_deactivation_function(self):
        ''' getter '''
        return self.__deactivation_function
    
    def set_deactivation_function(self, value):
        ''' setter '''
        self.__deactivation_function = value
    
    deactivation_function = property(get_deactivation_function, set_deactivation_function)

    def __init__(
        self,
        activation_function,
        deactivation_function=None,
        int filter_num=30,
        int channel=3,
        int kernel_size=3,
        int stride=1,
        int pad=1,
        double scale=1.0,
        params_initializer=ParamsInitializer(),
        params_dict={"loc": 0.0, "scale": 1.0}
    ):
        '''
        Init.
        
        Args:
            activation_function:    Activation function.
            deactivation_function:  Activation function for deconvolution.
                                    If you want to set differently activation functions 
                                    in standard convolution and in the transposed convolution 
                                    as a deconvolution, especially when constructing `ConvolutionalAutoEncoder`, 
                                    set this parameter.

            filter_num:             The number of kernels(filters).
            channel:                Channel of image files.
            kernel_size:            Size of the kernels.
            stride:                 Stride.
            pad:                    Padding.
            scale:                  Scale of parameters which will be `ParamsInitializer`.
            params_initializer:     is-a `ParamsInitializer`.
            params_dict:            `dict` of parameters other than `size` to be input to function `ParamsInitializer.sample_f`.
        '''
        if isinstance(params_initializer, ParamsInitializer) is False:
            raise TypeError("The type of `params_initializer` must be `ParamsInitializer`.")

        self.__activation_function = activation_function
        if deactivation_function is not None:
            self.__deactivation_function = deactivation_function
        else:
            from copy import deepcopy
            self.__deactivation_function = deepcopy(activation_function)

        self.__weight_arr = params_initializer.sample(
            size=(filter_num, channel, kernel_size, kernel_size),
            **params_dict
        ) * scale

        self.__bias_arr = np.zeros((filter_num, ))
        
        self.__stride = stride
        self.__pad = pad

    def set_readonly(self, value):
        ''' setter '''
        raise TypeError("This property must be read-only.")

    def get_stride(self):
        ''' getter '''
        return self.__stride

    stride = property(get_stride, set_readonly)

    def get_pad(self):
        ''' getter '''
        return self.__pad

    pad = property(get_pad, set_readonly)
