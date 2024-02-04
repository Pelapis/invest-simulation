from data_reader import Data_reader
from data_generator import Data_generator
from plotter import Plotter

if __name__ == "__main__":
    # Read data
    paths = ["./data/data_index.csv", "./data/data_maotai.csv", "./data/data_mengjie.csv"]
    data_reader = Data_reader(paths)
    return_vectors = data_reader.get_return_vectors()
    # Generate data
    data_generator = Data_generator(return_vectors, num_investors=100, trading_cost=0.001)
    plot_function = data_generator.get_plot_function()
    # Plot
    plotter = Plotter(plot_function, save_path="./plots/py")
    plotter.plot()
