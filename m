From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: New kvm-xfstests images uploaded
Date: Thu, 9 Mar 2017 14:31:39 +0200
Message-ID: <CAOQ4uxjvDR=qhQBd-QLcBpKZJZ5A=9PakbcK99T_Hs6STjMLGg@mail.gmail.com>
References: <20170306055827.omfoahfisn44l6bc@thunk.org> <CAOQ4uxiHM1UTAPRt6ambvbnL8eOqT3U2hbsrLJTTJ+wSVFOc-g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-ot0-f193.google.com ([74.125.82.193]:34304 "EHLO
        mail-ot0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932069AbdCIMbm (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 9 Mar 2017 07:31:42 -0500
In-Reply-To: <CAOQ4uxiHM1UTAPRt6ambvbnL8eOqT3U2hbsrLJTTJ+wSVFOc-g@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Cc: linux-unionfs@vger.kernel.org, Eryu Guan <eguan@redhat.com>, fstests <fstests@vger.kernel.org>

[re-sending with correct address of fstests list]

On Thu, Mar 9, 2017 at 2:29 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Mon, Mar 6, 2017 at 7:58 AM, Theodore Ts'o <tytso@mit.edu> wrote:
>> I've uploaded a new kvm-xfstests image at:
>>
>> https://www.kernel.org/pub/linux/kernel/people/tytso/kvm-xfstests
>>
>> This has the latest xfstests, xfsprogs, and e2fsprogs update, as well
>> as changes to help debug problems in the journal_lazy patches:
>>
>> e2fsprogs       v1.43.4-27-g686994eb (Fri, 3 Mar 2017 10:02:14 -0500)
>> fio             fio-2.17-1-g54441e7 (Wed, 18 Jan 2017 08:18:28 -0700)
>> quota           e0b6335 (Thu, 9 Feb 2017 11:55:45 +0100)
>> stress-ng       4ad62e1 (Mon, 27 Feb 2017 14:28:36 -0500)
>> xfsprogs        v4.10.0-rc1 (Wed, 15 Feb 2017 21:48:31 -0600)
>> xfstests-bld    032c8c3 (Fri, 3 Mar 2017 21:03:05 -0500)
>> xfstests        linux-v3.8-1414-g999e3f6 (Sun, 5 Mar 2017 19:11:35 -0500)
>
> Ted,
>
> That is not an xfstests commit (is it??)
>
> The reason I am asking is because I want to change kvm-xfstests
> overlay cfg scripts to use the new xfstests overlay config. e.g.::
>
> SIZE=large
> export TEST_DEV=$LG_TST_DEV
> export TEST_DIR=$LG_TST_MNT
> export SCRATCH_DEV=$LG_SCR_DEV
> export SCRATCH_MNT=$LG_SCR_MNT
>
> The benefit of this setup is (quoting myself) "to help catch overlayfs bugs
> related to leaking objects in underlying (base) fs", because with this
> setup, base fs is cycle mounted after every test.
>
> This change requires xfstests commit
> 33e4199 ("overlay: use OVL_BASE_SCRATCH_MNT instead of SCRATCH_DEV")
>
> Currently, xfstests-bld default config file does not even include a
> default value
> for XFSTESTS_COMMIT.
>
> Should I just go on and send you a patch and let you (and other
> xfstests-bld users)
> worry about using a recent enough version of xfstests?
