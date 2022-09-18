#!/usr/bin/python
import os
import gi

gi.require_version('Gtk', '3.0')
gi.require_version('AppIndicator3', '0.1')

from gi.repository import Gtk as gtk
from gi.repository import AppIndicator3 as appindicator

home=os.getenv('HOME')

def main():
  indicator = appindicator.Indicator.new("customtray", home + "/.config/sway/img/rec.png", appindicator.IndicatorCategory.APPLICATION_STATUS)
  indicator.set_status(appindicator.IndicatorStatus.ACTIVE)
  indicator.set_menu(menu())
  gtk.main()

def menu():
  menu = gtk.Menu()
  item_stop= gtk.MenuItem(label="Parar gravação")
  item_discard=gtk.MenuItem(label="Descartar gravação")
  item_stop.connect('activate',stop)
  item_discard.connect('activate',discard)
  menu.append(item_stop)
  menu.append(item_discard)

  menu.show_all()

  return menu
  

def stop(_):
    gtk.main_quit()
    os.system("sudo marecord stop " + home)

def discard(_):
    gtk.main_quit()
    os.system("sudo marecord discard " + home)


if __name__ == "__main__":
  main()

