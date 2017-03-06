From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v4 1/6] vfs: create vfs helper vfs_tmpfile()
Date: Mon, 6 Mar 2017 17:29:16 +0200
Message-ID: <CAOQ4uxjqVKOPj_yCs=b=HUSFRqHb4RXruvDZYddPj=jvMh8HCA@mail.gmail.com>
References: <1484627697-17262-1-git-send-email-amir73il@gmail.com>
 <1484627697-17262-2-git-send-email-amir73il@gmail.com> <2523.1488812352@jrobl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-ot0-f195.google.com ([74.125.82.195]:33979 "EHLO
        mail-ot0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753700AbdCFP3X (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 6 Mar 2017 10:29:23 -0500
In-Reply-To: <2523.1488812352@jrobl>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: "J. R. Okajima" <hooanon05g@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Mon, Mar 6, 2017 at 4:59 PM, J. R. Okajima <hooanon05g@gmail.com> wrote:
> Amir Goldstein:
>> Factor out some common vfs bits from do_tmpfile()
>> to be used by overlayfs for concurrent copy up.
>
> Hmm, just to copy-up.
> I have no objection this factoring-out, but do you have any specific
> reason for overlayfs NOT to support i_op->tmpfile()?

No reason. Just someone has to do the leg work.

>
> If you try supporting it in the future, then the parameter open_flag may
> become a problem. I guess that you will make ovl_tmpfile() (currently
> not exist) to call vfs_tmpfile(), and pass dummy 0 as open_flag as
> overlayfs copy-up does. But such dummy parameter will make the created
> tmpfile un-linkable by a user I am afraid.
>

I don't think that's going to be a problem.
ovl_link() can probably make sure that I_LINKABLE is propagated to upper
inode before calling vfs_link() for a tmpfile.
