From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH] ovl: fix uid/gid when creating over whiteout
Date: Wed, 15 Jun 2016 16:09:47 +0200
Message-ID: <CAJfpegvopC3wA9YQ9J5khG3nCJ9zeXTpZ-SMj515vF5RMXEhNQ@mail.gmail.com>
References: <20160615133002.GA11993@veci.piliscsaba.szeredi.hu>
	<20160615140151.GB19388@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:35933 "EHLO
	mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753380AbcFOOJs (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Wed, 15 Jun 2016 10:09:48 -0400
Received: by mail-oi0-f67.google.com with SMTP id d132so4187646oig.3
        for <linux-unionfs@vger.kernel.org>; Wed, 15 Jun 2016 07:09:48 -0700 (PDT)
In-Reply-To: <20160615140151.GB19388@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, Jun 15, 2016 at 4:01 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Wed, Jun 15, 2016 at 03:30:02PM +0200, Miklos Szeredi wrote:

>> --- a/fs/overlayfs/dir.c
>> +++ b/fs/overlayfs/dir.c
>> @@ -405,12 +405,21 @@ static int ovl_create_or_link(struct den
>>               err = ovl_create_upper(dentry, inode, &stat, link, hardlink);
>>       } else {
>>               const struct cred *old_cred;
>> +             struct cred *override_cred;
>>
>>               old_cred = ovl_override_creds(dentry->d_sb);
>>
>> -             err = ovl_create_over_whiteout(dentry, inode, &stat, link,
>> -                                            hardlink);
>> +             err = -ENOMEM;
>> +             override_cred = prepare_creds();
>> +             if (override_cred) {
>> +                     override_cred->fsuid = old_cred->fsuid;
>> +                     override_cred->fsgid = old_cred->fsgid;
>
> Hi Miklos,
>
> I am wondering if we are switching to tasks's ->fsuid and ->fsgid too
> early. ovl_create_over_whiteout() calls ovl_lookup_temp(workdir) and
> IIUC, task might not have permission to do lookup in workdir.
>
> Should we switch to this override_cred, just before ovl_create_real()
> so that task ->fsuid and ->fsgid are used only for creation purposes
> only.

For lookup in workdir only CAP_DAC_OVERRIDE should matter, the actual
value of the fsuid and fsgid should be irrelevant (user, group and
others all have zero permission on workdir).

Thanks,
Miklos
