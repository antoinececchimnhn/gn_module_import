import { NgModule } from "@angular/core";
import { CommonModule } from '@angular/common';
import { GN2CommonModule } from "@geonature_common/GN2Common.module";
import { Routes, RouterModule } from "@angular/router";

import { MatStepperModule } from '@angular/material/stepper';
import { MatButtonModule } from '@angular/material/button';
import {MatIconModule} from '@angular/material/icon';

import { ImportComponent } from "./components/import.component";
import { ImportProcessComponent } from "./components/import-process.component";
import { ImportModalDatasetComponent } from "./components/import-modal-dataset.component";
import { DataService } from "./services/data.service";

// my module routing
const routes: Routes = [
  { path: "", component: ImportComponent },
  { path: "process", component: ImportProcessComponent}
];

@NgModule({
  declarations: [
    ImportComponent,
    ImportProcessComponent,
    ImportModalDatasetComponent
  ],

  imports: [
    GN2CommonModule, 
    RouterModule.forChild(routes), 
    CommonModule,
    MatStepperModule,
    MatIconModule
  ],

  entryComponents: [
    ImportModalDatasetComponent
  ],

  providers: [
    DataService
  ],

  bootstrap: []
})

export class GeonatureModule {}
