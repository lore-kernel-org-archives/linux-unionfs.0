Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20191022204453.97058-1-salyzyn@android.com> <CAOQ4uxjFqq0zA7V3A9s0h2om7AWY5AT-2sQ4z2G0Vk2gtf1M=w@mail.gmail.com>
 <c0eb1b6e-65f6-9d38-64b9-333f3e82905a@android.com>
In-Reply-To: <c0eb1b6e-65f6-9d38-64b9-333f3e82905a@android.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 24 Oct 2019 08:28:23 +0300
Message-ID: <CAOQ4uxj4Hy9E-rGyM9bihyoFhi9h2DunFWFBAyYMDef=XyrrEQ@mail.gmail.com>
Subject: Re: [PATCH v14 0/5] overlayfs override_creds=off & nested get xattr fix
Content-Type: text/plain; charset="UTF-8"
To: Mark Salyzyn <salyzyn@android.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

> > I remember asking - don't remember the answer -
> > do you have any testing for this feature?
> Yes, on an unnamed 4.19-based and mainline-based Android and virtual
> cuttlefish product ... which was critically unworkable without this
> patch series.

Of course you *tested* it - I meant did you write any automated tests
that other developers can run to verify that feature won't break with future
changes.
Many people run xfstests with overlayfs, where most of the tests run
as root.
Few people run unionmount testsuite with overlayfs where most of
the tests run as root.
So none of those tests have coverage for override_creds=off.

> > I have a WIP branch to run unionmount-testsuite not as root,
> > which is a start, but I didn't get to finish the work.
> > Let me know if you want to take up this work.
> Please refer it in private email to me, no guarantees, my cycles are so
> sparse right now that it took a month to respin this patch series to
> upstream. If I can make it test on Android with overlayfs activated, big
> gain.

It's here:
https://github.com/amir73il/unionmount-testsuite/commits/run_as_bin

As far as I can tell, the test code in the branch is working, but it fails
on permissions in one of the early create file test cases and I did not
have time to look into it.

What it does is to drop capabilities to uid 1 before executing the test
cases. In between test cases, for the test setup it reverts back to uid 0.

For your Android use case, you may want to have uid's 0/1
configurable to different uid's? the first (setup) uid obviously needs to
be capable of mounting overlayfs.

Not sure how you would go about changing security context?
Probably, you would need to have the test setup code execute
"./run --ov --set-up" via init service command.

Cheat sheet for running the test:

pre requisite python3
sudo mkdir -p /lower /upper /mnt
sudo ./run --ov

Thanks,
Amir.
