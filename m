Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C411DC433EF
	for <linux-unionfs@archiver.kernel.org>; Sun, 27 Feb 2022 04:29:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229992AbiB0E3n (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 26 Feb 2022 23:29:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230005AbiB0E3f (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 26 Feb 2022 23:29:35 -0500
Received: from sender2-op-o12.zoho.com.cn (sender2-op-o12.zoho.com.cn [163.53.93.243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9607C366A2
        for <linux-unionfs@vger.kernel.org>; Sat, 26 Feb 2022 20:28:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1645936107; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=A6rKnATZFxdt0VXU3YcrUxjlbX0wnHY8hckwktU95s3QcilgXu//HS9tYFUbvS/DLWxm8HQjwuW/24txGsX6cBz5s8hk2CNU4Pe26EbX7EAcaiIXT+deQyKfL2Owt1vM/gJjRJwq/ZMZC6UXm+ym+t98DHyVZOPDtK7KYuV2vO4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1645936107; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=pERuZ2ozsv3PGyQ1zNR6lhpCDNmN/NYCO8iaHKMytIE=; 
        b=LscdFn9fnbH6UKD8QzA9UVrv7OA31kdnbDFmaGbHZSznMiitzyL08fX36/96gtT2pGxlESSGjpUTitl7AqebwsBSO9dFO8Ia3NrcfFUvsWkiIkueYD9bqEwnXHWvA7A1R50eyHlBhPVKfCQlFnbn6MpCiDY6APBkFX+wtzMXfQM=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1645936107;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=Date:MIME-Version:Subject:To:Cc:References:From:Message-ID:In-Reply-To:Content-Type:Content-Transfer-Encoding;
        bh=pERuZ2ozsv3PGyQ1zNR6lhpCDNmN/NYCO8iaHKMytIE=;
        b=NmKOd7VGfETw6hH2mIH9up84jsWW20Jw4QAoYh0KNVs3BfXNNccX6+o/jd4fHY6A
        Ym58SQ9RZk3+EwFC1p7wzUZhrT1IvBEEWr2DmXrzMC2/TGXE510v3ov3MEfeQ6EahHp
        a2yoU0W4sm8GFpDDeMtJDO80s78ChxLAqfs9cE98=
Received: from [192.168.255.10] (113.116.49.66 [113.116.49.66]) by mx.zoho.com.cn
        with SMTPS id 16459361050296.727596844342997; Sun, 27 Feb 2022 12:28:25 +0800 (CST)
Date:   Sun, 27 Feb 2022 12:28:23 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [RFC PATCH] ovl: fsync parent directory in copy-up
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>
References: <20220226152058.288353-1-cgxu519@mykernel.net>
 <CAOQ4uxiWZ4TWq4LuNOHYMHDgX+2Srq_3HNe+t5z-Ch4AFw9bRA@mail.gmail.com>
From:   Chengguang Xu <cgxu519@mykernel.net>
Message-ID: <3a37de83-a48d-e0b5-f934-c4b4219de7fe@mykernel.net>
In-Reply-To: <CAOQ4uxiWZ4TWq4LuNOHYMHDgX+2Srq_3HNe+t5z-Ch4AFw9bRA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-ZohoCNMailClient: External
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

=E5=9C=A8 2022/2/27 0:38, Amir Goldstein =E5=86=99=E9=81=93:
> On Sat, Feb 26, 2022 at 5:21 PM Chengguang Xu <cgxu519@mykernel.net> wrot=
e:
>> Calling fsync for parent directory in copy-up to
>> ensure the change get synced.
> It is not clear to me that this change is really needed
> What if the reported problem?

I found this issue by eyeball scan when I was looking for
the places which need to mark overlay inode dirty in change.

However, I think there are still some real world cases will be impacted=20
by this kind of issue,
for example, using docker build to make new docker image and power=20
failure makes new
image inconsistant.


>
> Besides this can impact performance in some workloads.
>
> The difference between parent copy up and file copy up is that
> failing to fsync to copied up data and linking/moving the upper file
> into place may result in corrupted data after power failure if temp
> file data is not synced.
>
> Failing the fsync the parent dir OTOH may result in revert to
> lower file data after power failure.
>
> The thing is, although POSIX gives you no such guarantee, with
> ext4/xfs fsync of the upper file itself will guarantee that parents
> will be present after power failure (see [1]).

In the new test case (079) which I posted, I've tried xfs as underlying=20
fs and found the parent of
copy-up file didn't present after power failure. Am I missing something?


>
> This is not true for btrfs, but there are fewer users using overlayfs
> over btrfs (at least in the container world).
>
> So while your patch is certainly "correct", for most users its effects
> will be only negative - performance penalty without fixing anything.
> So I think this change should be opt-in with Kconfig/module/mount option.

I prefer to add this as standard option, but if Miklos and you guys all=20
think it should be opt-in then
mount option is also acceptable for me.


Thanks,
Chengguang

>
> Unfortunately, there is currently no way to know whether the underlying
> filesystem needs the parent dir fsync or not.
> I was trying to promote a VFS API for a weaker version of fsync for
> the parent dir [2] but that effort did not converge.
>
> Thanks,
> Amir.
>
> [1] https://lore.kernel.org/linux-fsdevel/1552418820-18102-1-git-send-ema=
il-jaya@cs.utexas.edu/
> [2] https://lore.kernel.org/linux-fsdevel/20190527172655.9287-1-amir73il@=
gmail.com/
>
>> Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
>> ---
>>   fs/overlayfs/copy_up.c | 15 +++++++++++++++
>>   1 file changed, 15 insertions(+)
>>
>> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
>> index e040970408d4..52ca915f04a3 100644
>> --- a/fs/overlayfs/copy_up.c
>> +++ b/fs/overlayfs/copy_up.c
>> @@ -944,6 +944,7 @@ static int ovl_copy_up_one(struct dentry *parent, st=
ruct dentry *dentry,
>>   {
>>          int err;
>>          DEFINE_DELAYED_CALL(done);
>> +       struct file *parent_file =3D NULL;
>>          struct path parentpath;
>>          struct ovl_copy_up_ctx ctx =3D {
>>                  .parent =3D parent,
>> @@ -972,6 +973,12 @@ static int ovl_copy_up_one(struct dentry *parent, s=
truct dentry *dentry,
>>                                    AT_STATX_SYNC_AS_STAT);
>>                  if (err)
>>                          return err;
>> +
>> +               parent_file =3D ovl_path_open(&parentpath, O_WRONLY);
>> +               if (IS_ERR(parent_file)) {
>> +                       err =3D PTR_ERR(parent_file);
>> +                       return err;
>> +               }
>>          }
>>
>>          /* maybe truncate regular file. this has no effect on dirs */
>> @@ -998,6 +1005,14 @@ static int ovl_copy_up_one(struct dentry *parent, =
struct dentry *dentry,
>>                          err =3D ovl_copy_up_meta_inode_data(&ctx);
>>                  ovl_copy_up_end(dentry);
>>          }
>> +
>> +       if (!err) {
>> +               if (parent_file) {
>> +                       vfs_fsync(parent_file, 0);
>> +                       fput(parent_file);
>> +               }
>> +       }
>> +
>>          do_delayed_call(&done);
>>
>>          return err;
>> --
>> 2.27.0
>>
>>


