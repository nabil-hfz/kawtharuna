



import { Entity, Column, ManyToOne, JoinColumn } from 'typeorm';
import { AppBaseEntity } from './base.entity';
import { LocalizedEntity } from './localized.entity';
import { ReciterEntity } from './reciter.entity';

@Entity({ name: 'khatmat' })
export class KhatmaEntity extends AppBaseEntity {

  @Column(type => LocalizedEntity)
  name!: LocalizedEntity;

  @Column()
  recitationType!: number;

  @Column({ default: 0 })
  totalDownloads!: number;

  @Column({ default: 0 })
  totalPlays!: number;

  // @ManyToOne(() => Author, (author) => author.photos)

  @ManyToOne((type) => ReciterEntity, //(reciter) => reciter.image,
   {
    eager: true,
  })
  @JoinColumn()
  reciter?: ReciterEntity;
}