From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v3 9/9] overlay: mount/unmount base fs before/after
 running tests
Date: Tue, 14 Feb 2017 19:55:46 +0200
Message-ID: <CAOQ4uxgV++ZdecBfUth2TN4A451hP_7UXRkBkgVhOTEwCzhNMA@mail.gmail.com>
References: <1486932224-17075-1-git-send-email-amir73il@gmail.com>
 <1486932224-17075-10-git-send-email-amir73il@gmail.com> <20170214002356.dxrmf5jzwr6sivlu@thunk.org>
 <CAOQ4uxj131n=dadiuCzJZWTTC0Jkw=Bdpp1QpX=keBOOySYySg@mail.gmail.com> <20170214170757.nuhxnvhtctreelxt@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-ot0-f196.google.com ([74.125.82.196]:34136 "EHLO
        mail-ot0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753221AbdBNRzr (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 14 Feb 2017 12:55:47 -0500
In-Reply-To: <20170214170757.nuhxnvhtctreelxt@thunk.org>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Cc: Eryu Guan <eguan@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests <fstests@vger.kernel.org>

On Tue, Feb 14, 2017 at 7:07 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Tue, Feb 14, 2017 at 08:43:36AM +0200, Amir Goldstein wrote:
>>
>> Correct. The only thing that overlay does not do is format the base fs,
>> as the README says:
>>         - for overlay tests: ./check -overlay [test(s)]
>>           The TEST and SCRATCH partitions should be pre-formatted
>>           with another base fs, where the overlay dirs will be created
>>
>
> So this means that if I only want to do the equivalent of:
>
>    gce-xfstests -c overlay generic/013
>
> as part of a bisection search, it's impossible to do this via the
> config file and "./check -s ext4-overlay generic/013" alone.  Someone
> who wants to do this will have to use their own wrapper script to
> format the base file system with the proper file system.
>
> Correct?
>

Correct.

I guess it wouldn't be that hard to add mkfs/fsck support for base fs,
but for now my budget to deal with this is over. I may get to it another
time.

> Which is fine, I have my own wrapper script system.  :-)
>

Do we have something like:
./check -s ext4 --setup-only

Should we have something like this?

Will this do the trick?
./check -s ext4 -n generic/013
