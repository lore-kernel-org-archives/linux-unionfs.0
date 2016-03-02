From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH] ovl: fix working on distributed fs as lower layer
Date: Wed, 2 Mar 2016 15:18:58 +0100
Message-ID: <CAJfpegtOaV+DsqGJjbqCoMCcG50DAwYGvpcn4iqR3MTUT+CCGw@mail.gmail.com>
References: <145424653619.10827.10119853770850679426.stgit@zurg>
	<56C57928.2010606@kyup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:35259 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563AbcCBOS7 (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Wed, 2 Mar 2016 09:18:59 -0500
Received: by mail-oi0-f51.google.com with SMTP id c203so61226084oia.2
        for <linux-unionfs@vger.kernel.org>; Wed, 02 Mar 2016 06:18:59 -0800 (PST)
In-Reply-To: <56C57928.2010606@kyup.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Nikolay Borisov <kernel@kyup.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Kernel Mailing List <linux-kernel@vger.kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>

On Thu, Feb 18, 2016 at 8:56 AM, Nikolay Borisov <kernel@kyup.com> wrote:
>
>
> On 01/31/2016 03:22 PM, Konstantin Khlebnikov wrote:
>> This adds missing .d_select_inode into alternative dentry_operations.
>>
>> Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
>> Fixes: 7c03b5d45b8e ("ovl: allow distributed fs as lower layer")
>> Fixes: 4bacc9c9234c ("overlayfs: Make f_path always point to the overlay and f_inode to the underlay")
>> ---
>>  fs/overlayfs/super.c |    1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
>> index e6ae59c7119c..1a354840f262 100644
>> --- a/fs/overlayfs/super.c
>> +++ b/fs/overlayfs/super.c
>> @@ -343,6 +343,7 @@ static const struct dentry_operations ovl_dentry_operations = {
>>
>>  static const struct dentry_operations ovl_reval_dentry_operations = {
>>       .d_release = ovl_dentry_release,
>> +     .d_select_inode = ovl_d_select_inode,
>>       .d_revalidate = ovl_dentry_revalidate,
>>       .d_weak_revalidate = ovl_dentry_weak_revalidate,
>>  };
>
> I wish I had seen this patch earlier than
> https://marc.info/?l=linux-unionfs&m=145494313009959
>
>
> Reviewed-by: Nikolay Borisov <kernel@kyup.com>
> Tested-by: Nikolay Borisov <kernel@kyup.com>
>

Thanks for the patch, queued.

Miklos
