From: Rock Lee <rockdotlee@gmail.com>
Subject: Re: [PATCH] ovl: fix dir cache leak for ovl_cache_get
Date: Fri, 5 May 2017 14:34:19 +0800
Message-ID: <CAL-1w2tQmJFxu+72wkKu9wZznx0wE-UX24cFzCG=3XfEY4PETQ@mail.gmail.com>
References: <1493881633-3451-1-git-send-email-rockdotlee@gmail.com> <CAOQ4uxinf7VO+=LnUkBjgCAQvUB-4nwP6vMPM4Orcq2FvgQdKg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f194.google.com ([209.85.213.194]:35691 "EHLO
        mail-yb0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752862AbdEEGeV (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 5 May 2017 02:34:21 -0400
Received: by mail-yb0-f194.google.com with SMTP id 19so1312373ybl.2
        for <linux-unionfs@vger.kernel.org>; Thu, 04 May 2017 23:34:20 -0700 (PDT)
In-Reply-To: <CAOQ4uxinf7VO+=LnUkBjgCAQvUB-4nwP6vMPM4Orcq2FvgQdKg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org

Hi, Amir:

> This is not a leak. dir cache is refcounted and freed on
> ovl_dir_{release|reset}() -> ovl_cache_put()

Here is the snippet:

if (cache && ovl_dentry_version_get(dentry) == cache->version) {
cache->refcount++;
return cache;
}

ovl_set_dir_cache(dentry, NULL);

I am a little confused here. From the logic of the code, there must
have a circumstance --- cache is not NULL and
ovl_dentry_version_get(dentry) != cache->version. If
ovl_set_dir_cache(dentry, NULL), we can't find the old dir cache  form
dentry and struct file(later, file->private_data->cache will point at
the same dir cache with dentry). How could we free it in
ovl_dir_{release|reset} ?

BTW, could you please an example when ovl_dentry_version_get(dentry)
!= cache->version in ovl_cache_get ?

Thanks for your time.
-- 
Cheers,
Rock
