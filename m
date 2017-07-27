From: Tahsin Erdogan <tahsin@google.com>
Subject: Re: xattr hash error in 4.13-rc with overlayfs over ext4
Date: Thu, 27 Jul 2017 11:20:36 -0700
Message-ID: <CAAeU0aM-1UFJJvX3zF1wUjBeG8BGC+S0wn7PhiDZevTscvmkXg@mail.gmail.com>
References: <CAJfpegvQhuMnt=2TtfYSiMV=DTLLLbOfrvcR2xQrmvyPU9wSNg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f174.google.com ([209.85.161.174]:34478 "EHLO
        mail-yw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751458AbdG0SUh (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 27 Jul 2017 14:20:37 -0400
Received: by mail-yw0-f174.google.com with SMTP id i6so77404141ywb.1
        for <linux-unionfs@vger.kernel.org>; Thu, 27 Jul 2017 11:20:37 -0700 (PDT)
In-Reply-To: <CAJfpegvQhuMnt=2TtfYSiMV=DTLLLbOfrvcR2xQrmvyPU9wSNg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Theodore Ts'o <tytso@mit.edu>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, linux-fsdevel@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

Hi Miklos,
I made a first attempt to reproduce the failure but did not get lucky.

> Inode 3093, i_blocks is 16, should be 8.  Fix<y>? yes
Does this inode correspond to foo, bar or a preexisting file?

Do you mind sharing the output of the following command?
debugfs -R "stat <3093>" /dev/${ext4_dev}

thanks
