Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAJfpegvZH0+2jLpNbF445ykSGWbwV8-C=VzTYX2NnWfOot2yDg@mail.gmail.com>
References: <1522333133-24772-1-git-send-email-amir73il@gmail.com>
 <1522333133-24772-7-git-send-email-amir73il@gmail.com> <CAJfpegvZH0+2jLpNbF445ykSGWbwV8-C=VzTYX2NnWfOot2yDg@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 29 Mar 2018 19:37:52 +0300
Message-ID: <CAOQ4uxj+KCkN+nwxySbstRd-qoCnVuWT7-sNDybwvgfULS0wRA@mail.gmail.com>
Subject: Re: [PATCH v9 6/7] ovl: add support for "xino" mount option
Content-Type: text/plain; charset="UTF-8"
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Mar 29, 2018 at 6:28 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Thu, Mar 29, 2018 at 4:18 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> With mount option "xino", mounter declares that there are enough
>> free high bits in underlying fs to hold the layer fsid.
>> If overlayfs does encounter underlying inodes using the high xino
>> bits reserved for layer fsid, a warning will be emitted and the original
>> inode number will be used.
>>
>> The mount option name "xino" goes after a similar meaning mount option
>> of aufs, but in overlayfs case, the mapping is stateless.
>>
>> An example for a use case of "xino" is when upper/lower is on an xfs
>> filesystem. xfs uses 64bit inode numbers, but it currently never uses the
>> upper 8bit for inode numbers exposed via stat(2) and that is not likely to
>> change in the future without user opting-in for a new xfs feature. The
>> actual number of unused upper bit is much larger and determined by the xfs
>> filesystem geometry (64 - agno_log - agblklog - inopblog). That means
>> that for all practical purpose, there are enough unused bits in xfs
>> inode numbers for more than OVL_MAX_STACK unique fsid's.
>>
>> Another example for a use case of "xino" is when upper/lower is on tmpfs.
>> tmpfs inode numbers are allocated sequentially since boot, so they will
>> practially never use the high inode number bits.
>>
>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>> ---
>>  fs/overlayfs/ovl_entry.h |  1 +
>>  fs/overlayfs/super.c     | 34 ++++++++++++++++++++++++++++++++--
>>  2 files changed, 33 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
>> index 6a077fb2a75f..e830470c77bd 100644
>> --- a/fs/overlayfs/ovl_entry.h
>> +++ b/fs/overlayfs/ovl_entry.h
>> @@ -18,6 +18,7 @@ struct ovl_config {
>>         const char *redirect_mode;
>>         bool index;
>>         bool nfs_export;
>> +       bool xino;
>>  };
>>
>>  struct ovl_sb {
>> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
>> index d7284444f404..26a5db244081 100644
>> --- a/fs/overlayfs/super.c
>> +++ b/fs/overlayfs/super.c
>> @@ -352,6 +352,8 @@ static int ovl_show_options(struct seq_file *m, struct dentry *dentry)
>>         if (ofs->config.nfs_export != ovl_nfs_export_def)
>>                 seq_printf(m, ",nfs_export=%s", ofs->config.nfs_export ?
>>                                                 "on" : "off");
>> +       if (ofs->config.xino)
>> +               seq_puts(m, ",xino");
>>         return 0;
>>  }
>>
>> @@ -386,6 +388,7 @@ enum {
>>         OPT_INDEX_OFF,
>>         OPT_NFS_EXPORT_ON,
>>         OPT_NFS_EXPORT_OFF,
>> +       OPT_XINO,
>>         OPT_ERR,
>>  };
>>
>> @@ -399,6 +402,7 @@ static const match_table_t ovl_tokens = {
>>         {OPT_INDEX_OFF,                 "index=off"},
>>         {OPT_NFS_EXPORT_ON,             "nfs_export=on"},
>>         {OPT_NFS_EXPORT_OFF,            "nfs_export=off"},
>> +       {OPT_XINO,                      "xino"},
>>         {OPT_ERR,                       NULL}
>>  };
>>
>> @@ -513,6 +517,10 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
>>                         config->nfs_export = false;
>>                         break;
>>
>> +               case OPT_XINO:
>> +                       config->xino = true;
>> +                       break;
>> +
>>                 default:
>>                         pr_err("overlayfs: unrecognized mount option \"%s\" or missing value\n", p);
>>                         return -EINVAL;
>> @@ -1197,9 +1205,31 @@ static int ovl_get_lower_layers(struct ovl_fs *ofs, struct path *stack,
>>                 ofs->numlower++;
>>         }
>>
>> -       /* When all layers on same fs, overlay can use real inode numbers */
>> -       if (!ofs->numlowerfs || (ofs->numlowerfs == 1 && !ofs->upper_mnt))
>> +       /*
>> +        * When all layers on same fs, overlay can use real inode numbers.
>> +        * With mount option "xino", mounter declares that there are enough
>> +        * free high bits in underlying fs to hold the unique fsid.
>> +        * If overlayfs does encounter underlying inodes using the high xino
>> +        * bits reserved for fsid, it emits a warning and uses the original
>> +        * inode number.
>> +        */
>> +       if (!ofs->numlowerfs || (ofs->numlowerfs == 1 && !ofs->upper_mnt)) {
>>                 ofs->xino_bits = 0;
>> +               ofs->config.xino = false;
>> +       } else if (ofs->config.xino && !ofs->xino_bits) {
>> +               /*
>> +                * This is a roundup of number of bits needed for numlowerfs+1
>> +                * (i.e. ilog2(numlowerfs+1 - 1) + 1). fsid 0 is reserved for
>> +                * upper fs even with non upper overlay.
>> +                */
>> +               BUILD_BUG_ON(ilog2(OVL_MAX_STACK) > 31);
>> +               ofs->xino_bits = ilog2(ofs->numlowerfs) + 1;
>
> Shouldn't this be
>
>   ilog2(ofs->numlowerfs + (ofs->upper_mnt ? 1 : 0))
>
> ?
>
> Upper layer doesn't require a separate bit, just a separate fsid slot.
>

+1 is not for upper fs bit its for round up.
This is confusing hence the comment above.
ilog2(2^N+a) returns log2 or the "rounded down" value (i.e. N).
So for 2^N+a fsids we need N+1 bits.
The accurate expression is therefore:

 ilog2(ofs->numlowerfs + (ofs->upper_mnt ? 1 : 0) - 1) + 1

However, for simplicity, if there is no upper_mnt, first fsid is still 1
so I ommitted the condition and left with

 ilog2(ofs->numlowerfs + 1 - 1) + 1

I leave it to you as an exercise to see how hard it would be to get
rid of not reserving fsid 0 for upper fs (it makes reference into the
lower_fs array conditional on upper_mnt.
Maybe I just didn't try hard enough or wasn't creative enough.
Anyway, I did not think it was important not reserving 1 fsid for
non upper case.

Thanks,
Amir.
