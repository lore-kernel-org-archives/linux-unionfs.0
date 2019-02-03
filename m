Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20181207121027.GA5996@dnyarri> <CAJfpegsu6DUHVVac2PSyGoFW4pAKm3UH0XLg5+SMvN5XZmNzFw@mail.gmail.com>
 <20190202172914.GA17406@dnyarri> <CAOQ4uxh0L_u-UzJAcQ=QO+D-9VkoSy2HHofXig4=AqDo0vWTmg@mail.gmail.com>
 <20190203101340.GA6934@dnyarri>
In-Reply-To: <20190203101340.GA6934@dnyarri>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sun, 3 Feb 2019 15:51:53 +0200
Message-ID: <CAOQ4uxhBbAX5QizTAaBaSeUUmtOewzFcqb+RpxDxaz_5P5d7fQ@mail.gmail.com>
Subject: Re: Failure to execute file on overlayfs during switch_root/chroot
Content-Type: text/plain; charset="UTF-8"
To: aszlig <aszlig@nix.build>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, graham@grahamc.com, samuel@dionne-riel.com
List-ID: <linux-unionfs@vger.kernel.org>

On Sun, Feb 3, 2019 at 12:13 PM aszlig <aszlig@nix.build> wrote:
>
> On Sun, Feb 03, 2019 at 07:37:55AM +0200, Amir Goldstein wrote:
> > Any access? or just execute? Can you share pr_debug output of access
> > to file that is not execute?
>
> Sure, same result (EPERM) there, here is the output and the changed Nix
> expression (in case you want to reproduce it):
>
> https://gist.github.com/aszlig/0b5ae4b03208a117b6f737772ff0eed8
>
> I also added a stat on these files to check whether it happens there as well,
> but it only occurs when reading them.
>
> Here is the relevant pr_debug output:
>
> open(000000007ee735e6[/regular_top/l], 0100000) -> (0000000080f3d7f9, 00)
> open(00000000f7778f73[somesubdir/regular_sub/l], 0100000) -> (0000000080f3d7f9, 00)
>

OK, what I don't understand and requires debugging is that the print of
(realfile, IS_ERR(realfile) ? 0 : realfile->f_flags) suggests that
realfile is not
an error value and realfile->f_flags are 0.
Looking at the code following open_with_fake_path() I don't see the code
path that makes that possible, so if you are able to add debugging prints
down the call chain to find how exactly that came to be, that would be useful
for nailing down the problem.

> > FWIW, I ran unionmount-testsuite (tweaked) with 9p as lower as it passed,
> > so no obvious regressions with 9p as lower.
>
> Okay, one other thing that I can think of is that might be triggering the issue
> is that the Nix build process (on the host side) runs in a chroot with a few
> separate namespaces[1], including a mount namespace.
>

Perhaps. But I don't see how.

Thanks,
Amir.
