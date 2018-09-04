Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20180904145453.GD1469@redhat.com>
In-Reply-To: <20180904145453.GD1469@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 4 Sep 2018 18:32:38 +0300
Message-ID: <CAOQ4uxi+3Rh=yh9LWUnR6p8kk-ko2i_YmGFhVxzcMjqCC-qX1A@mail.gmail.com>
Subject: Re: What's the right/expected behavior with metacopy=off
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Tue, Sep 4, 2018 at 5:54 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> Hi Miklos/Amir,
>
> I have a query about metacopy behavior with metacopy=off.
>
> As of now, metacopy=off still continues to check for metacopy xattr,
> and if a metacopy file is found, data copy up takes place when file
> is opened for write. And there are other paths in getattr() for reporting
> number of blocks of lower file etc.
>
> IOW, metacopy=off does not turn off metacopy functionality completely.
> It only disables metacopy for new copy up operations. Anything which
> is already metadata copy up (due to previous mounts), that will continue
> to work as if metacopy=on was specified during mount.
>
> I am wondering is this the right way to do things. I did this because
> we don't have a functionality to detect and warn if current mount options
> are incompatible with existing state of file system. Ideally, I think
> we should warn/error out if an fs is mounted with metacopy=off and it was
> mounted with metacopy=on in the past. And metacopy=off should disable
> metacopy path completely (irrespective of the fact whether previously
> it was mounted with metacopy=on or not).
>
> Given we don't have such feature in overlayfs yet, I thought continuing
> to honor metacopy files even if metacopy=off, will be path of least
> surprise for a user.
>
> I want to revisit this question while we are still in -rc phase and
> before it becomes a completely supported mode.
>
> What do you folks think about it.
>

What is the threat model of attacker using metacopy?
TBH, I don't fully understand the threat model with redirect_dir
that required the addition of redirect_dir=nofollow.
Who auto mounts an upper layer from USB drive over sensitive
lower paths?

Let's see, an attacker wants to access a file that is root owned 0600
so attacker crafts a metacopy with its own ownership above the
root owned file.

Now the same thing an attacker could do with a merge dir to get
read/lookup access to a root owned directory, so metacopy does
not introduce this alleged attack vector, but it enhances it with the
ability to access files that are read-only for root.

If that threat is considered series to some users, I would advise
against adding metacopy=follow/nofollow options and reusing
existing ofs->config.redirect_follow to determine if data should
be followed from a metacopy upper when metacopy=off.

The rational is that redirect_dir=follow/nofollow really only
means behavior=usability/paranoia.

Thanks,
Amir.
