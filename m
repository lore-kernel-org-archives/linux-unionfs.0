From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 11/11] ovl: Put barriers to order oi->__upperdentry and
 OVL_METACOPY update
Date: Wed, 18 Oct 2017 08:40:59 +0300
Message-ID: <CAOQ4uxg6Y7LU_JffejeteT11PT5rqGhUASNgk-hTdngGOqmAjg@mail.gmail.com>
References: <1508274358-17456-1-git-send-email-vgoyal@redhat.com> <1508274358-17456-12-git-send-email-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:51506 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965152AbdJRFlA (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 18 Oct 2017 01:41:00 -0400
Received: by mail-qt0-f196.google.com with SMTP id h4so8430426qtk.8
        for <linux-unionfs@vger.kernel.org>; Tue, 17 Oct 2017 22:41:00 -0700 (PDT)
In-Reply-To: <1508274358-17456-12-git-send-email-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Wed, Oct 18, 2017 at 12:05 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> OVL_METACOPY in oi->flags can be accessed in lockless manner. So if a file
> is being copied up metadata only, we need to make sure that upperdentry is
> visible only after OVL_METACOPY flag has been set. IOW, if oi->__upperdentry
> is visble to a cpu, then we also need to make sure any updates to OVL_METACOPY
> flags are visible too.
>

You know, I have a feeling that this ordering requirement could be simplified or
completely avoided if you flip the meaning of the flag, i.e.:

bool ovl_dentry_has_upper_data(struct dentry *dentry)
{
        return ovl_test_flag(OVL_UPPER_DATA, d_inode(dentry));
}

Then flag visibility requirements are the same as visibility requirements
for oe->has_upper.
You probably don't need to add any new barriers for setting setting the flag
on normal copy up.
For setting the flag in copy_up_meta_inode_data, and testing the flag
in ovl_d_real() the requirements stay the same as you implemented in patch 10.

Am I wrong?
