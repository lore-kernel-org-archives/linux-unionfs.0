From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 2/4] overlay: use default overlay mount options _overlay_mount_dirs()
Date: Wed, 27 Sep 2017 10:50:46 +0300
Message-ID: <CAOQ4uxhr+1g0Pa8-UPTfG2k-ebU1aCygsXfwmFjjgrpf-gFq2Q@mail.gmail.com>
References: <1506495852-7295-1-git-send-email-amir73il@gmail.com> <1506495852-7295-3-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f179.google.com ([209.85.161.179]:50337 "EHLO
        mail-yw0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750917AbdI0Hur (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 27 Sep 2017 03:50:47 -0400
In-Reply-To: <1506495852-7295-3-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>, Vivek Goyal <vgoyal@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>

On Wed, Sep 27, 2017 at 10:04 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> Tests that use _overlay_mount_dirs() should also use the
> default overlay mount options.

Vivek, Eryu,

I should make a disclaimer here: I did not test with SELINUX_MOUNT_OPTIONS
because I have no SELinux in my test setup.

Specifically, I am concerned that tests that compose "special" overlay mounts,
like tmpfs mounts and stacked overlay mounts (overlay/029) may not play well
with SELINUX_MOUNT_OPTIONS applied to the special mounts.
I am less concerned about the tests that were converted to use
_overlay_scratch_mount_dirs() helper.

Can either of you run a -g overlay/quick test with this series and valid
SELINUX_MOUNT_OPTIONS?

Thanks,
Amir.
