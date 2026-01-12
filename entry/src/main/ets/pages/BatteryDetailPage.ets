import { common } from '@kit.AbilityKit'
import BatteryTable from '../data/BatteryTable'
import BatteryRecord from '../model/BatteryRecord'
import ConstantUI from '../util/ConstantUI'

const BG = '#0B0F14'
const CARD = '#141A21'
const TEXT = '#E6EEF7'
const SUBTEXT = '#9BB0C3'
const DIVIDER = '#223043'

@Component
export struct BatteryDetailPage {
  @Consume('NavPathStack') pageStack: NavPathStack
  @State records: BatteryRecord[] = []

  aboutToAppear(): void {
    BatteryTable.getAll(this.getUIContext().getHostContext() as common.UIAbilityContext, (rows) => {
      this.records = rows.reverse()
    })
  }

  private formatTimestamp(ts: string): string {
    try {
      const date = new Date(ts)
      const pad = (n: number): string => n < 10 ? `0${n}` : `${n}`
      return `${pad(date.getDate())}.${pad(date.getMonth() + 1)} ${pad(date.getHours())}:${pad(date.getMinutes())}`
    } catch {
      return ts
    }
  }

  private getBadgeColor(percentage: number): Color {
    if (percentage <= 15) {
      return Color.Red
    }
    if (percentage <= 40) {
      return Color.Orange
    }
    return Color.Green
  }

  @Builder
  private buildEmptyState() {
    Column() {
      Text('No records yet')
        .fontSize(14)
        .fontColor(SUBTEXT)
        .textAlign(TextAlign.Center)
        .margin({ bottom: 8 })
      Button('Back')
        .type(ButtonType.Normal)
        .onClick(() => this.pageStack.pop())
    }
    .width('100%')
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .layoutWeight(1)
  }

  @Builder
  private buildBatteryItem(item: BatteryRecord) {
    Row() {
      Column() {
        Text(`${item.batteryPct}`)
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
        Text('%')
          .fontSize(9)
          .fontColor(Color.White)
          .opacity(0.85)
      }
      .width(40)
      .height(40)
      .backgroundColor(this.getBadgeColor(item.batteryPct))
      .borderRadius(20)
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .margin({ right: 8 })

      Column({ space: 2 }) {
        Text(`Battery ${item.batteryPct}%`)
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
          .fontColor(TEXT)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })

        Text(this.formatTimestamp(item.ts))
          .fontSize(11)
          .fontColor(SUBTEXT)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.Center)

      Blank()
    }
    .padding({ left: 10, right: 10, top: 8, bottom: 8 })
    .width('100%')
    .height('100%')
    .backgroundColor(CARD)
    .borderRadius(12)
    .shadow(1)
    .border({ width: 0.5, color: DIVIDER })
  }

  @Builder
  private buildRecordsList() {
    List({ space: 6 }) {
      ForEach(this.records, (item: BatteryRecord) => {
        ListItem() {
          this.buildBatteryItem(item)
        }
        .padding({ left: 6, right: 6 })
      }, (item: BatteryRecord) => item.id?.toString() ?? item.ts)
    }
    .layoutWeight(1)
    .width('100%')
    .height('100%')
    .padding({ top: 2 })
    .edgeEffect(EdgeEffect.None)
  }

  build() {
    NavDestination() {
      Column({ space: 8 }) {
        Text('Battery History')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .fontColor(TEXT)
          .textAlign(TextAlign.Center)
          .margin({ top: 6, bottom: 2 })

        if (this.records.length === 0) {
          this.buildEmptyState()
        } else {
          this.buildRecordsList()

          Row({ space: 10 }) {
            Button('Back')
              .type(ButtonType.Capsule)
              .onClick(() => this.pageStack.pop())
          }
          .margin({ top: 6 })
        }
      }
      .width(ConstantUI.FULL_WIDTH)
      .height(ConstantUI.FULL_HEIGHT)
      .padding(10)
      .backgroundColor(BG)
      .alignItems(HorizontalAlign.Center)
    }
    .hideTitleBar(true)
  }
}

@Builder
export function BatteryDetailBuilder() {
  BatteryDetailPage()
}