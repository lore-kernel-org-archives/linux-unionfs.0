Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 8 Jan 2020 09:27:12 +0200
Message-ID: <CAOQ4uxjFC81hikgg0WaF0Z3Mxkk3iDakKx2Ttuhp_L_2Tnc6xQ@mail.gmail.com>
Subject: Re: OverlaysFS offline tools
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, StuartIanNaylor <rolyantrauts@gmail.com>, Linux Containers <containers@lists.linux-foundation.org>, kmxz <kxzkxz7139@gmail.com>, "zhangyi (F)" <yi.zhang@huawei.com>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

[-fsdevel,+containers]

> On Thu, Apr 18, 2019 at 1:58 PM StuartIanNaylor <rolyantrauts@gmail.com> wrote:
> >
> > Apols to ask here but are there any tools for overlayFS?
> >
> > https://github.com/kmxz/overlayfs-tools is just about the only thing I
> > can find.
>
> There is also https://github.com/hisilicon/overlayfs-progs which
> can check and fix overlay layers, but it hasn't been updated in a while.
>

Hi Vivek (and containers folks),

Stuart has pinged me on https://github.com/StuartIanNaylor/zram-config/issues/4
to ask about the status of overlayfs offline tools.

Quoting my answer here for visibility to more container developers:

I have been involved with implementing many overlayfs features in the
kernel in the
past couple of years (redirect_dir,index,nfs_export,xino,metacopy).
All of these features bring benefits to end users, but AFAIK, they are
all still disabled
by default in containers runtimes (?) because lack of tools support
(e.g. migration
/import/export). I cannot force anyone to use the new overlayfs
features nor to write
offline tools support for them.

So how can we improve this situation?

If the problem is development resources then I've had great experience
in the past
with OSS internship programs like Google summer of code (GSoC):
Organizations, such as Redhat or mobyproject.org, can participate in the program
by posting proposals for open source projects.
Developers, such as myself, volunteer to mentors projects and students apply
to work on them.

IIRC, the timeline for GSoC for project proposals in around April. Applying as
an organization could be before that.

Vivek, since you are the only developer I know involved in containers runtime
projects I am asking you, but really its a question for all container developers
out there.

Are you aware of missing features in containers that could be met by filling the
gaps with overlayfs offline tools?
Are you a part of an organization that could consider posting this sort of
project proposals to GSoC or other internship programs?

Thanks,
Amir.
