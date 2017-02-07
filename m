From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2 1/3] overlay: configure base fs mount point for running tests
Date: Tue, 7 Feb 2017 15:32:51 +0200
Message-ID: <CAOQ4uxgXXEAkUZ5AWS7S10gKFufxSpgVtF5U_wCXPk_WYo_QFw@mail.gmail.com>
References: <1485507365-29012-1-git-send-email-amir73il@gmail.com>
 <1485507365-29012-2-git-send-email-amir73il@gmail.com> <20170207123514.GK1859@eguan.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-ot0-f194.google.com ([74.125.82.194]:32776 "EHLO
        mail-ot0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754007AbdBGNcx (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 7 Feb 2017 08:32:53 -0500
In-Reply-To: <20170207123514.GK1859@eguan.usersys.redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests <fstests@vger.kernel.org>

On Tue, Feb 7, 2017 at 2:35 PM, Eryu Guan <eguan@redhat.com> wrote:
> On Fri, Jan 27, 2017 at 10:56:03AM +0200, Amir Goldstein wrote:
>> Instead of setting the vars TEST/SCRATCH_DEV to overlay base dirs,
>> allow setting the vars SCRATCH/TEST_BASE_MNT, to configure where
>> the base fs is mounted and where overlay dirs will be created.
>> For example:
>>
>> -export TEST_DEV=/mnt/base/test/ovl
>> -export SCRATCH_DEV=/mnt/base/scratch/ovl
>> +export TEST_BASE_MNT=/mnt/base/test
>> +export SCRATCH_BASE_MNT=/mnt/base/scratch
>
> [sorry for the late review, I came back from holiday then played with
> this patchset for a while]
>
> Hmm, I noticed that there're TEST/SCRATCH_BASE_MNT and
> TEST/SCRATCH_BASE_DIR and OVERLAY_BASE_DIR introduced. They seem a bit
> complex and can be confusing to users. I'm wondering if they can be
> simplified somehow? e.g. use TEST/SCRATCH_BASE_MNT only, no ..BASE_DIR
> vars, no OVERLAY_BASE_DIR (which seems not necessary to me, it only adds
> another level to the path structure).

I find the extra level necessary.
For example, I use the same BASE_DEV for other tests, so I would like
to isolate overlayfs tests under ovl dir.
If we were to support mkfs of BASE_DEV that would have been different
but we don't.

However, I will try to get rid of some of the variables to reduce confusion.
IMO, _BASE_DIR, which replaces the bogus TEST/SCRATCH_DEV is
important for tests that mount their own custom overlays, e.g. overlay/005.
I will try to see how this can be simplified or better explained.
Please give this another thought as well.

>
> And I gave the variables naming a second thought, I think
> TEST/SCRATCH_BASE_MNT are confusing, they're used only in overlayfs
> testing, but the names seem to imply they're generic enough and useful
> in other filesystems testing too. I'd like to name them with little
> confusion. OTOH, I agree that adding "OVERLAY_" prefix is not good
> enough either (names too long).
>
> I'm not good at naming variables.., just a random idea in my head, how
> about using OVL_ prefix? i.e.
>
> OVL_TEST/SCRATCH_BASE_MNT, a bit shorter, and indicates they're only
> useful in overlayfs testing, but OVL_ prefix introduces inconsistency
> (with OVERLAY_UPPER_DIR etc., perhaps we can change all OVERLAY_ to
> OVL_?).
>

Yes, I considered OVL_ as well. I guess it is the least worse option.
No problem to align OVL_UPPER/LOWER_DIR. Will do.
