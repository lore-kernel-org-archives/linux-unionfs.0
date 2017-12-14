From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v4 1/3] common/rc: add scratch shutdown support for overlayfs
Date: Thu, 14 Dec 2017 17:06:34 +0200
Message-ID: <CAOQ4uxjuLKDe1E2YQPnQNMjEjZDvZgb3jmVTZArSo167ZmCaJw@mail.gmail.com>
References: <1513261145-127502-1-git-send-email-cgxu519@icloud.com>
 <CAOQ4uxi3BD8-RA9AU-VUa_yumXq=e=7a5o8843F3mcMaD-Vk2g@mail.gmail.com> <20171214150248.GI2749@eguan.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-vk0-f66.google.com ([209.85.213.66]:35485 "EHLO
        mail-vk0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753114AbdLNPGg (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 14 Dec 2017 10:06:36 -0500
In-Reply-To: <20171214150248.GI2749@eguan.usersys.redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Chengguang Xu <cgxu519@icloud.com>, fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>

On Thu, Dec 14, 2017 at 5:02 PM, Eryu Guan <eguan@redhat.com> wrote:
> On Thu, Dec 14, 2017 at 04:46:21PM +0200, Amir Goldstein wrote:
>> On Thu, Dec 14, 2017 at 4:19 PM, Chengguang Xu <cgxu519@icloud.com> wrote:
>> > check -overlay overrides SCRATCH_MNT variable to it's own,
>> > so adjust target to underlying filesystem(OVL_BASE_SCRATCH_MNT)
>> > when running shutdown on overlayfs.
>> >
>> > Introduce a helper _scratch_shutdown to mainly handle scratch
>> > shutdown and convert godown to _scratch_shutdown to support
>> > overlayfs running on below cases.
>>
>> You should do this in 2 patches:
>> 1. replace all open coded godown calls with _scratch_shutdown helper
>> 2. Add overlay support to _scratch_shutdown helper.
>
> The description is not clear enough, the updates are not for running
> existing shutdown tests to run on overlay, but to avoid test failures
> using the bare 'src/godown $SCRATCH_MNT' when _require_scratch_shutdown
> accepts overlay to run. e.g.
>
> +/root/xfstests/src/godown: error on xfsctl(GOINGDOWN) of "/mnt/scratch/ovl-mnt": Inappropriate ioctl for device
>
> So I think it's proper to do all the required updates in one patch,
> instead of introducing (intermediate) false failures, and fixing them in
> a follow-up patch.
>

I take your word for it. In that case, I'll wait for the patch will
clearer description.

Amir.
