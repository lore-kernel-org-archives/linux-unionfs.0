Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20190607010431.11868-1-mcoffin13@gmail.com> <20190607205105.21858-1-mcoffin13@gmail.com>
In-Reply-To: <20190607205105.21858-1-mcoffin13@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sat, 8 Jun 2019 12:04:54 +0300
Message-ID: <CAOQ4uximPqsNivkqD36LdNfT4g41v2rtDm+OB6t2z40dpWs_og@mail.gmail.com>
Subject: Re: [PATCH v2] overlay: allow config override of metacopy/redirect defaults
Content-Type: text/plain; charset="UTF-8"
To: Matt Coffin <mcoffin13@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Vivek Goyal <vgoyal@redhat.com>
List-ID: <linux-unionfs@vger.kernel.org>

Hi Matt,

Thank you for trying to address this, but I see problems both in Why and
How you did it.

On Fri, Jun 7, 2019 at 11:51 PM Matt Coffin <mcoffin13@gmail.com> wrote:
>
> [Why]
> Currently, if the redirect_dir option is set as a kernel or module
> parameter, then even if metacopy is only enabled config, then both
> metacopy and redirect_dir will be enabled when one creates a mount
> point. This is not desirable because /sys/module/overlay/parameters will
> still report that redirect_dir is not enabled

/sys/module/overlay/parameters reports that redirect_dir is not enabled
*by default* not per mount.

> and there will be no redirect_dir=on line in the mount options in /proc/mounts.

That is a bug. This code:
/* Automatically enable redirect otherwise. */
config->redirect_follow = config->redirect_dir = true;

Needs to update of config->redirect_mode.

You are very welcome to send a fix patch.

> The behavior
> of setting redirect_dir globally for overlay is likely a common pattern
> on docker workstations, as redirect_dir makes for slower building of
> docker images.

I haven't been following the progress in docker w.r.t redirect_dir,
but IMO the right way for docker is to always mandate overlayfs
mount option parameters based on user meaningful storage driver
config options, see:
https://github.com/moby/moby/pull/34342#issuecomment-320669900

Instead of depending on admin to set /sys/module/overlay/parameters
globally, docker should always pass explicit redirect_dir,metacopy
values in mount options.
Docker should check for existence of /sys/module/overlay/parameters
feature file to know if kernel supports the mount option.

BTW, docker should be treating metacopy exactly the same way as
redirect_dir because the native diff driver does not know about metacopy,
so docket should (IMO) disable metacopy in mount option unless user
explicitly opted-in for in per image and fallback to naiive diff driver if
user opted-in to enable metacopy.

IMO, docker overlay2 storage driver should have a well documented
user meaningful per container option such as:
"optimize for efficient runtime" (redirect_dir=on,metacopy=on)
vs.
"optimize for efficient image export" (redirect_dir=off,metacopy=off)

Or even simpler:
"Exportable = true/false"
Because users know if they run a container that they don't intend
to export. In that case, it makes no sense to deny user of the benefits
of redirect_dir=on,metacopy=on.

>
> [How]
> This patch adds similar logic to that already in place for parsing mount
> parameters. If the user explicitly sets redirect_dir via a kernel or
> module parameter, then metacopy will become disabled, unless it was also
> specified that way. Obviously, mount options still take precedence over
> this process, so this logic only kicks in when neither redirect_dir or
> metacopy were specified in the mount options.
>

If even we did pass the "Why", the "How" is unacceptable IMO.
It extends something that is already a local special case hack
with redirect_opt/metacopy_opt.

If we ever try to improve parameter/config/option parsing
and dependency checks we need to do it in a much more generic
way and there are much more things to consider.
I am sorry that I cannot provide you guidelines for how to
do this. I took a stab at this once, then Miklos said he will try to
redo it and came back with:
"...this is more complicated than I thought."
https://marc.info/?l=linux-unionfs&m=154110487305120&w=2

If you do insist to try and follow this path, my only suggestion
is - start with a patch to Documentation/filesystems/overlayfs.txt.
If you cannot shortly and properly describe the behavior of
your change in documentation it is a no go.

Thanks,
Amir.
