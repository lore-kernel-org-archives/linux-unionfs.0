From: Pavel Emelyanov <xemul@virtuozzo.com>
Subject: Re: [PATCH 1/2] ovl: support freeze/thaw super
Date: Mon, 23 Jan 2017 16:23:35 +0300
Message-ID: <588603D7.4060500@virtuozzo.com>
References: <1484828008-27507-1-git-send-email-amir73il@gmail.com>
 <1484828008-27507-2-git-send-email-amir73il@gmail.com>
 <CAOQ4uxg-i0SMXRTDdPS2GxWKUYDKAu30wT9bjXX1Gd2CzeJ2Yg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-db5eur01on0109.outbound.protection.outlook.com ([104.47.2.109]:43872
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750703AbdAWNTB (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 23 Jan 2017 08:19:01 -0500
In-Reply-To: <CAOQ4uxg-i0SMXRTDdPS2GxWKUYDKAu30wT9bjXX1Gd2CzeJ2Yg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>
Cc: Jan Kara <jack@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On 01/23/2017 11:47 AM, Amir Goldstein wrote:
> On Thu, Jan 19, 2017 at 2:13 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> freeze/thaw of upper is all that is needed.
>>
> 
> Miklos,
> 
> Looking at it again, I believe that not even that is needed.
> Having fixed ovl_sync_fs() with patch #2, ovl_freeze()
> and ovl_unfreeze() need to be NOP. Am I right?
> 
> In fact, freezing upper fs, when many overlayfs mounts
> share the same base fs (a-la docker) would be quite lame.
> 
> WRT other use cases of freezing overlayfs, I am not sure
> if it is needed for correctness of docker checkpoint/restart?
> 
> Pavel?

Thanks for the heads-up :)

Good question. Actually we haven't yet experimented with doing _full_
(with FS) snapshot of containers, but at the first glance I can't
see the need for OVL freeze :( We stop all the processes in entry.S
effectively, so no in-flight IO can be happening.

>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>> ---
>>  fs/overlayfs/super.c | 16 ++++++++++++++++
>>  1 file changed, 16 insertions(+)
>>
>> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
>> index 6792bb7..0f8a9c8 100644
>> --- a/fs/overlayfs/super.c
>> +++ b/fs/overlayfs/super.c
>> @@ -160,6 +160,20 @@ static void ovl_put_super(struct super_block *sb)
>>         kfree(ufs);
>>  }
>>
>> +static int ovl_freeze(struct super_block *sb)
>> +{
>> +       struct ovl_fs *ufs = sb->s_fs_info;
>> +
>> +       return ufs->upper_mnt ? freeze_super(ufs->upper_mnt->mnt_sb) : 0;
>> +}
>> +
>> +static int ovl_unfreeze(struct super_block *sb)
>> +{
>> +       struct ovl_fs *ufs = sb->s_fs_info;
>> +
>> +       return ufs->upper_mnt ? thaw_super(ufs->upper_mnt->mnt_sb) : 0;
>> +}
>> +
>>  /**
>>   * ovl_statfs
>>   * @sb: The overlayfs super block
>> @@ -222,6 +236,8 @@ static int ovl_remount(struct super_block *sb, int *flags, char *data)
>>
>>  static const struct super_operations ovl_super_operations = {
>>         .put_super      = ovl_put_super,
>> +       .freeze_fs      = ovl_freeze,
>> +       .unfreeze_fs    = ovl_unfreeze,
>>         .statfs         = ovl_statfs,
>>         .show_options   = ovl_show_options,
>>         .remount_fs     = ovl_remount,
>> --
>> 2.7.4
>>
> .
> 
