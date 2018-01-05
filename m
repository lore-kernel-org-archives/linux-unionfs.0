From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2 05/23] ovl: pass ovl_layer array to ovl_check_origin_fh()
Date: Fri, 5 Jan 2018 07:26:48 +0200
Message-ID: <CAOQ4uxhGWWOg902ujVVPRD9DKGoivgLLFzY4guUVwjWn8ayQsw@mail.gmail.com>
References: <1515084018-25134-1-git-send-email-amir73il@gmail.com>
 <1515084018-25134-6-git-send-email-amir73il@gmail.com> <20180104223525.GC2808@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f193.google.com ([209.85.213.193]:32873 "EHLO
        mail-yb0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751220AbeAEF0t (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 5 Jan 2018 00:26:49 -0500
Received: by mail-yb0-f193.google.com with SMTP id f16so1499190ybn.0
        for <linux-unionfs@vger.kernel.org>; Thu, 04 Jan 2018 21:26:49 -0800 (PST)
In-Reply-To: <20180104223525.GC2808@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, zhangyi <yi.zhang@huawei.com>, overlayfs <linux-unionfs@vger.kernel.org>

On Fri, Jan 5, 2018 at 12:35 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Thu, Jan 04, 2018 at 06:40:00PM +0200, Amir Goldstein wrote:
>> Pass the fs instance lower_layer array instead of lowerstack array to
>> ovl_check_origin_fh(), because the dentry member of ovl_path plays no
>> part in this helper.
>>
>> This change simplifies the argument list of ovl_check_origin(),
>> ovl_cleanup_index() and ovl_verify_index().
>>
>> We pass lower_layer array and numlower and not struct ovl_fs to
>> ovl_check_origin_fh(), because we are going to use this helper for
>> decoding upper layer file handles for NFS export support.
>>
>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>> ---
>>  fs/overlayfs/namei.c     | 25 +++++++++++--------------
>>  fs/overlayfs/overlayfs.h |  9 ++++-----
>>  fs/overlayfs/readdir.c   | 12 ++++++------
>>  fs/overlayfs/super.c     |  5 +----
>>  4 files changed, 22 insertions(+), 29 deletions(-)
>>
>> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
>> index 4cc8fb64c879..46a3e31b0225 100644
>> --- a/fs/overlayfs/namei.c
>> +++ b/fs/overlayfs/namei.c
>> @@ -292,16 +292,14 @@ static int ovl_lookup_layer(struct dentry *base, struct ovl_lookup_data *d,
>>
>>
>>  static int ovl_check_origin_fh(struct ovl_fh *fh, struct dentry *upperdentry,
>> -                            struct ovl_path *lower, unsigned int numlower,
>> +                            struct ovl_layer *layers, unsigned int numlayers,
>>                              struct ovl_path **stackp)
>
> I was thinking if this will lead to decoding in all lower layers (as opposed
> to only some depending on how many lower layers ovl_entry has stored). But
> looks like we already do decoding in all the lower layers of fs (both for
> origin and index). So this is not a concern.
>

So what happens today is that we are only decoding non-dir disconnected
origin in ovl_lookup().
If numlower > 1 and all of the lower layers are on same fs, we will decode
origin from the first lower layer and get an unreliable idx, because non-dir
origin could be on any of the lower layers.
But we don't really care on which layer non-dir origin is, we just need to
know its inode number (or copy its data).

But when decoding an NFS dir file handle it really does matters to get a
reliable layer idx.

Amir.
