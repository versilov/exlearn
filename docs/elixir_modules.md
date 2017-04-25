# Elixir modules API reference

Table items in bold are mandatory.

## `ExLearn.Matrix`

Creates matrices in both binary and tuple representation.

### `#new/1`

Creates a new matrix.

```elixir
list_of_lists = [[1, 2, 3], [4, 5, 6]]

ExLearn.Matrix.new(list_of_lists)
# <<2, 0, 0, 0, 3, 0, 0, 0, 0, 0, 128, 63, 0, 0, 0, 64, 0, 0, 64, 64, 0, 0, 128,
#   64, 0, 0, 160, 64, 0, 0, 192, 64>>
```

#### Parameters

##### `list_of_lists`

A `list` containing `lists` of the same length with values being `integers` or
`floats`.

Integers are converted to floats in the final binary representation.
The length of the top list is used to determine the number of rows.
The length of the first list inside the top list is used to determine the number
of columns.
If the internal lists are not of the same length or their contents are not
numbers then the function will crash.

Example:

```elixir
# A list representing a matrix with 2 rows and 3 columns.

list_of_lists = [[1, 2, 3], [4, 5, 6]]
```

### `#new/3`

Creates a new matrix.

```elixir
rows    = 2
columns = 3
list_of_lists = [[1, 2, 3], [4, 5, 6]]

ExLearn.Matrix.new(rows, columns, list_of_lists)
# <<2, 0, 0, 0, 3, 0, 0, 0, 0, 0, 128, 63, 0, 0, 0, 64, 0, 0, 64, 64, 0, 0, 128,
#   64, 0, 0, 160, 64, 0, 0, 192, 64>>
```

#### Parameters

##### `rows`

A `non_neg_integer` representing the number of rows the matrix has.

Example:

```elixir
rows = 2
```

##### `columns`

A `non_neg_integer` representing the number of columns the matrix has.

Example:

```elixir
columns = 3
```

##### `list_of_lists`

A `list` containing `lists` of the same length with values being `integers` or
`floats`.

Integers are converted to floats in the final binary representation.
The length of the top list is used to determine the number of rows.
The length of the first list inside the top list is used to determine the number
of columns.
If the internal lists are not of the same length or their contents are not
numbers then the function will crash.

Example:

```elixir
# A list representing a matrix with 2 rows and 3 columns.

list_of_lists = [[1, 2, 3], [4, 5, 6]]
```

### `#from_binary/1`

Creates an erlang term representation of a matrix from a binary.

### `#to_binary/1`

Creates a matrix binary from an erlang term representation.

### `valid?/1`

Checks if the argument is a valid representation of a matrix.


## `ExLearn.NeuralNetwork`

### `#create/1`

Creates the neural network processes and returns a handle.

```elixir
structure = %{
  layers: %{
    input:   %{size: 784, name: "Input",  dropout: 0.2                       },
    hidden: [%{size: 100, name: "Hidden", dropout: 0.5, activation: :logistic}],
    output:  %{size: 10,  name: "Output",               activation: :logistic}
  },
  objective:    :cross_entropy,
  presentation: :argmax
}

network = create(structure)
```

#### Parameters

##### `structure`

A `map` that defines the neural network structure.

| Key Name     | Value Type | About                                          |
|--------------|------------|------------------------------------------------|
| **layers**   | map        | [layers schema](#nn-create-layers)             |
| objective    | atom       | [objective schema](#nn-create-objective)       |
| presentation | atom       | [presentation schema](#nn-create-presentation) |

#### Return

The function returns a handle that must be passed to the other functions in order
for them to know on which network to operate.

#### Schemas

##### <a name="nn-create-layers"></a> `layers`

| Key Name   | Value Type | About                              |
|------------|------------|------------------------------------|
| **input**  | map        | [input schema](#nn-create-input)   |
| **hidden** | list       | [hidden schema](#nn-create-hidden) |
| **output** | map        | [output schema](#nn-create-output) |

##### <a name="nn-create-objective"></a> `objective`

| Value                      | Type | About |
|----------------------------|------|-------|
| `:cross_entropy`           | atom |       |
| `:negative_log_likelihood` | atom |       |
| `:quadratic`               | atom |       |

Default Value: `:quadratic`

##### <a name="nn-create-presentation"></a> `presentation`

| Value     | Type | About |
|-----------|------|-------|
| `:argmax` | atom |       |
| `:raw`    | atom |       |
| `:round`  | atom |       |

Default Value: `:raw`

##### <a name="nn-create-input"></a> `input`

| Key Name | Value Type  | About                                        |
|----------|-------------|----------------------------------------------|
| **size** | pos_integer | The number of neurons for the current layer. |
| dropout  | float       | The dropout probability, between [0, 1].     |
| name     | String.t    | Any non empty elixir string.                 |

##### <a name="nn-create-hidden"></a> `hidden`

| Key Name   | Value Type  | About                                        |
|------------|-------------|----------------------------------------------|
| **size**   | pos_integer | The number of neurons for the current layer. |
| activation | atom        | [activation schema](#nn-create-activation)   |
| dropout    | float       | The dropout probability, between [0, 1].     |
| name       | String.t    | Any non empty elixir string.                 |

##### <a name="nn-create-output"></a> `output`

| Key Name   | Value Type        | About                                        |
|------------|-------------------|----------------------------------------------|
| **size**   | pos_integer       | The number of neurons for the current layer. |
| activation | atom &#124; tuple | [activation schema](#nn-create-activation)   |
| name       | String.t          | Any non empty elixir string.                 |

##### <a name="nn-create-activation"></a> `activation`

| Value                    | Type                           | About |
|--------------------------|--------------------------------|-------|
| `:arctan`                | atom                           |       |
| `:bent_identity`         | atom                           |       |
| `:gaussian`              | atom                           |       |
| `:identity`              | atom                           |       |
| `:logistic`              | atom                           |       |
| `:relu`                  | atom                           |       |
| `:sinc`                  | atom                           |       |
| `:sinusoid`              | atom                           |       |
| `:softmax`               | atom                           |       |
| `:softplus`              | atom                           |       |
| `:softsign`              | atom                           |       |
| `:tanh`                  | atom                           |       |
| `{:elu, alpha: alpha}`   | tuple(atom, list(atom, float)) |       |
| `{:prelu, alpha: alpha}` | tuple(atom, list(atom, float)) |       |

Default Value: `:logistic`


### `#initialize/2`

Initializes the weights and biases of a neural network.

```elixir
# For the `normal` distribution:
initialization_parameters = %{
  distribution: :normal,
  deviation:    1,
  mean:         0
}

# For the `uniform` distribution:
initialization_parameters = %{
  distribution: :uniform,
  maximum:       1,
  minimum:      -1
}

network = initialize(network, initialization_parameters)
```

#### Parameters

##### `network`

A neural network created with the `#create/1` function described [previously](#create1).

##### `initialization_parameters`

A `map` that defines the way biases and weights are initialized.

| Key Name         | Value Type | About                                              |
|------------------|------------|----------------------------------------------------|
| **distribution** | atom       | [distribution schema](#nn-initialize-distribution) |
| deviation        | float      | Mandatory for the `:normal` distribution.          |
| mean             | float      | Mandatory for the `:normal` distribution.          |
| minimum          | float      | Mandatory for the `:uniform` distribution.         |
| maximum          | float      | Mandatory for the `:uniform` distribution.         |

#### Return

The function returns the neural network object it acted upon.

#### Schemas

##### <a name="nn-initialize-distribution"></a> `distribution`

| Value      | Type | About                                                                                                          |
|------------|------|----------------------------------------------------------------------------------------------------------------|
| `:normal`  | atom | Defines the use of the normal distribution and makes the `deviation` and `mean` parameters become mandatory.   |
| `:uniform` | atom | Defines the use of the uniform distribution and makes the `minimum` and `maximum` parameters become mandatory. |


### `#load/2`

### `#notification/2`

### `#predict/2` and `#predict/3`

### `#process/3`

### `#result/1`

### `#save/2`

### `#test/3`

### `#train/3`
