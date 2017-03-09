From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: New kvm-xfstests images uploaded
Date: Thu, 9 Mar 2017 18:25:04 +0200
Message-ID: <CAOQ4uxj7isLpfaou7VgXobt9iVrkVYLvpnATo98+m70dOjHQow@mail.gmail.com>
References: <20170306055827.omfoahfisn44l6bc@thunk.org> <CAOQ4uxiHM1UTAPRt6ambvbnL8eOqT3U2hbsrLJTTJ+wSVFOc-g@mail.gmail.com>
 <CAOQ4uxjvDR=qhQBd-QLcBpKZJZ5A=9PakbcK99T_Hs6STjMLGg@mail.gmail.com> <20170309154916.dtqvw6mk5rvlxgf5@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:32854 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753918AbdCIQZG (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 9 Mar 2017 11:25:06 -0500
In-Reply-To: <20170309154916.dtqvw6mk5rvlxgf5@thunk.org>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Cc: linux-unionfs@vger.kernel.org, Eryu Guan <eguan@redhat.com>, fstests <fstests@vger.kernel.org>

On Thu, Mar 9, 2017 at 5:49 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Thu, Mar 09, 2017 at 02:31:39PM +0200, Amir Goldstein wrote:
>> [re-sending with correct address of fstests list]
>>
[...]
>> > The reason I am asking is because I want to change kvm-xfstests
>> > overlay cfg scripts to use the new xfstests overlay config. e.g.::
>> >
>> > SIZE=large
>> > export TEST_DEV=$LG_TST_DEV
>> > export TEST_DIR=$LG_TST_MNT
>> > export SCRATCH_DEV=$LG_SCR_DEV
>> > export SCRATCH_MNT=$LG_SCR_MNT
>> >
>
> It's been on my todo list try out your patches and to make the
> appropriate adjustments to the overlay file system support code, but I
> haven't had the time to do this yet.  If you'd like to send me
> patches, please do feel free!
>

Change is trivial (as seen above)
I sent a github pull request
https://github.com/tytso/xfstests-bld/pull/4

Tested it with
kvm-xfstests -c overlay/large -g quick
