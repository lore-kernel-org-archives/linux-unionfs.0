Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20181207121027.GA5996@dnyarri> <CAJfpegsu6DUHVVac2PSyGoFW4pAKm3UH0XLg5+SMvN5XZmNzFw@mail.gmail.com>
 <20190202172914.GA17406@dnyarri>
In-Reply-To: <20190202172914.GA17406@dnyarri>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sun, 3 Feb 2019 07:37:55 +0200
Message-ID: <CAOQ4uxh0L_u-UzJAcQ=QO+D-9VkoSy2HHofXig4=AqDo0vWTmg@mail.gmail.com>
Subject: Re: Failure to execute file on overlayfs during switch_root/chroot
Content-Type: text/plain; charset="UTF-8"
To: aszlig <aszlig@nix.build>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, graham@grahamc.com, samuel@dionne-riel.com
List-ID: <linux-unionfs@vger.kernel.org>

On Sat, Feb 2, 2019 at 7:30 PM aszlig <aszlig@nix.build> wrote:
>
> Good morning,
>
> Apparently this mail (sent on 2019-01-29) didn't end up on the list, even
> though the MTA has accepted it, so I'm resending the mail without attachments.
>
> To get list readers on page, this is the description of the problem I've sent
> to Miklos a while ago:
>
> > Since kernel 4.19 our NixOS test suites are failing[1] with EPERM while
> > trying to switch_root from the initrd to a new overlayfs-mounted file system.
> >
> > The tests are running using a 9p[2] filesystem as the lowerdir[3].
> >
> > After bisecting I found a6518f73e60e5044656d1ba587e7463479a9381a to be the
> > culprit. I also tested by reverting said commit on top of the latest 4.19.7
> > stable kernel and the issue doesn't occur there.
> >
> > To reproduce this with Nix[4], the following command can be used:
> >
> > nix-build -I nixpkgs=channel:nixos-unstable '<nixpkgs/nixos/tests/latest-kernel.nix>'
>
> Unfortunately I have only been able to reproduce this with NixOS VM tests, so I
> still have no clue what could be wrong here. However, the problem turns out to
> not be related to switch_root, initrd and execve but generally seems to be an
> issue with our test scenario.
>
> The scenario with NixOS VM tests is as follows:
>
>   * It uses QEMU in conjunction with 9p to share /nix/store with the guest.
>   * The guest VM mounts that share in $targetRoot/nix/.ro-store during initrd.
>   * Still in initrd, an overlayfs is mounted on $targetRoot/nix/store with the
>     following options:
>
>      lowerdir=$targetRoot/nix/.ro-store
>      upperdir=$targetRoot/nix/.rw-store/store
>      workdir=$targetRoot/nix/.rw-store/work
>
>   * Since the aforementioned change however, file access to any of the files on
>     $targetRoot/nix/store and /nix/store (after the switch_root) fails with
>     EPERM.

Any access? or just execute? Can you share pr_debug output of access
to file that is not execute?

>
> I haven't yet been able to pin down which part of this exactly causes the
> error, but running overlayfs without 9p works so I *think* it might be related
> to 9p or possibly remote file systems in general (don't remember exactly, but I
> think I tried it with sshfs as well)?
>

FWIW, I ran unionmount-testsuite (tweaked) with 9p as lower as it passed,
so no obvious regressions with 9p as lower.

> Right now, we're shortly before our next stable release and while reverting
> a6518f73e60e5044656d1ba587e7463479a9381a fixes the issue above, it breaks
> overlayfs elsewhere[5].
>
> On Fri, Dec 07, 2018 at 01:59:59PM +0100, Miklos Szeredi wrote:
> > Not sure what debug options are available; would you be able to strace
> > the switch_root process?  Enable pr_debug for overlayfs ( echo "file
> > fs/overlayfs/* +p" > <debugfs>/dynamic_debug/control)?
>
> The full log, the output of strace -f and the Nix expression file I was using
> for the test, along with the kernel config can be found here:
>
> https://gist.github.com/aszlig/2eb6be1d1af38313c6b0584ea6a8d0c8
>

This is strange:
machine# [   26.971185] open(000000009b67c2dd[/find/l], 0100040) ->
(00000000cfca6162, 00)

realfile doesn't look like IS_ERR but realfile flags are 0.

I don't see how that can happen???

Thanks,
Amir.
