From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: v4.13 overlay fs: sometimes fails when creating or moving files
Date: Fri, 8 Sep 2017 17:20:50 +0300
Message-ID: <CAOQ4uxjC+ONu9nj-BJ8XwuWU0ofq5ySd-YRmXdikQjPAXj3WuA@mail.gmail.com>
References: <20170908143704.3c74d20f@localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f169.google.com ([209.85.161.169]:35289 "EHLO
        mail-yw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751166AbdIHOUv (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 8 Sep 2017 10:20:51 -0400
Received: by mail-yw0-f169.google.com with SMTP id q80so7880272ywg.2
        for <linux-unionfs@vger.kernel.org>; Fri, 08 Sep 2017 07:20:50 -0700 (PDT)
In-Reply-To: <20170908143704.3c74d20f@localdomain>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Jordi Pujol Palomer <jordipujolp@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>

On Fri, Sep 8, 2017 at 3:37 PM, Jordi Pujol Palomer
<jordipujolp@gmail.com> wrote:
> Hello,
>
> Found some errors when doing a remaster of a filesystem image in Linux v
> 4.13,
> the filesystem is mounted in overlay and then modifying the
> system into the chroot.
> The upgrade process fails when renaming or moving files.
> Sometimes the same process runs right and sometimes wrong,
>

This sounds a lot like https://bugzilla.redhat.com/show_bug.cgi?id=1213602
A long standing issue with a simple workaround (see link above)

Is the problem you are hitting new to v4.13?

Thanks
Amir.
