# Elixir modules API reference

Table items in bold are mandatory.

## `ExLearn.NeuralNetwork`

### `#create\1`

Initializes the neural network processes and returns a handle. 

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

| Key Name     | Value Type | About                                          |
|--------------|------------|------------------------------------------------|
| **layers**   | map        | [layers schema](#nn-create-layers)             |
| objective    | atom       | [objective schema](#nn-create-objective)       |
| presentation | atom       | [presentation schema](#nn-create-presentation) |

#### Return

The function return a handle that must be passed to the other functions in order
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
| activation | atom &#124; tuple | [activation schema](#nn-create-activation).  |
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
