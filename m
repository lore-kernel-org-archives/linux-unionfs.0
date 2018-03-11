Return-Path: <cgxu519@gmx.com>
MIME-Version: 1.0
Message-ID: <trinity-019c25f3-a146-4f9c-b8c2-a8cfdb385922-1520738185097@3c-app-mailcom-bs10>
From: "Chengguang Xu" <cgxu519@gmx.com>
Subject: Re: "quota-df" feature
Content-Type: text/plain; charset=UTF-8
Date: Sun, 11 Mar 2018 04:16:25 +0100
In-Reply-To: <CAOQ4uxiMQnRa4Ke7FW-G-xiwU3xs9wB1EKb7ocNzYOm1NL=fKQ@mail.gmail.com>
References: <trinity-cf8cc163-74dd-4b20-8372-28cbce5bfa47-1520427171633@3c-app-mailcom-bs03>
 <CAOQ4uxji73iSXeS-keVrH264iXZs6-4XkGS2rQYU2AsjT6JikQ@mail.gmail.com>
 <trinity-c4776725-d637-418a-a2f1-b317c3ed3144-1520475704072@3c-app-mailcom-bs01>
 <CAOQ4uxgcz4sAwQ6iD2dAE1aRJ6ddeJDJSLOh4g3SteKDhW6ZRA@mail.gmail.com>
 <trinity-4ed0aac2-30d8-4778-94d5-a954ba0dcacf-1520501014692@3c-app-mailcom-bs01>
 <CAOQ4uxhg0wanMESYcTdR0PFX3vdic_kT9VUWs-vqOaaJpB9sCw@mail.gmail.com>
 <trinity-974e4490-4aff-47c5-bab5-9b62491f0303-1520514601365@3c-app-mailcom-bs03>
 <CAOQ4uxggkzDMGUO0e-_a_XSOShQJF5ikFVGxT1XEGAAz_85Uwg@mail.gmail.com>
 <trinity-8980c52f-6054-4ad0-b49e-d17f6d9139d2-1520663870763@3c-app-mailcom-bs10>
 <CAOQ4uxiMQnRa4Ke7FW-G-xiwU3xs9wB1EKb7ocNzYOm1NL=fKQ@mail.gmail.com>
To: Amir Goldstein <amir73il@gmail.com>, yi.zhang@huawei.com
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

> Sent: Sunday, March 11, 2018 at 4:03 AM
> From: "Amir Goldstein" <amir73il@gmail.com>
> To: "Chengguang Xu" <cgxu519@gmx.com>
> Cc: overlayfs <linux-unionfs@vger.kernel.org>, "Miklos Szeredi" <miklos@szeredi.hu>
> Subject: Re: "quota-df" feature
>
> On Sat, Mar 10, 2018 at 8:37 AM, Chengguang Xu <cgxu519@gmx.com> wrote:
> >> Sent: Thursday, March 08, 2018 at 10:36 PM
> >> From: "Amir Goldstein" <amir73il@gmail.com>
> >> To: "Chengguang Xu" <cgxu519@gmx.com>
> >> Cc: overlayfs <linux-unionfs@vger.kernel.org>, "Miklos Szeredi" <miklos@szeredi.hu>
> >> Subject: Re: "quota-df" feature
> >>
> >> On Thu, Mar 8, 2018 at 3:10 PM, Chengguang Xu <cgxu519@gmx.com> wrote:
> >> [...]
> >> >> >> > Lowerdirs could be share with different overlayfs, so I'm not sure counting
> >> >> >> > the contents of lowerdirs is proper behavior or not. If lowerdirs are dedicated
> >> >> >> > to one overlayfs then maybe setting same project id with upperdir can resolve
> >> >> >> > "covered" problem that you mentioned above. Counting usage information without
> >> >> >> > quota might be a hard work when having plenty of files.
> >> >> >> >
> >> >> >>
> >> >> >> Well, its a different use case, but a very well known use case -
> >> >> >> When dealing with cloned files (e.g. btrfs, xfs) many files can share the same
> >> >> >> blocks, but each clone is fully accounted to the user/group/project.
> >> >> >> This is the "thin provisioning" use case - every user gets accounted by files
> >> >> >> that the user can reference, but the host does not pay the cost of sum of all
> >> >> >> user quotas.
> >> >> >>
> >> >> >> Without accounting of "covered" files to begin with, is it possible to
> >> >> >> get to a state
> >> >> >> where 'touch' on a big file gets ENOSPC/EQUOTA. This is indeed a situation that
> >> >> >> can happen in "thin provisioned" filesystems (e.g. btrfs) or on thin
> >> >> >> provisioned block,
> >> >> >> but a situation that filesystems and administrators try really hard to avoid.
> >> >> >
> >> >> > Let me make clear about the term of "covered", is it meaning hidden file in lowerdir
> >> >> > because of same named file exists in upperdir? or is it meaning the contents in
> >> >> > lowerdir but in the merged dir of overlayfs?
> >> >> >
> >> >> >
> >> >>
> >> >> The former. "covered" file size does not show up in du -s, so the
> >> >> merged disk usage
> >> >> is <upper used> + <lower used> - <covered used>
> >> >
> >> > Thanks, got it.
> >> > But IIUC, "covered" file does not have chance to copy-up, so
> >> > I'm wondering is it the real reason for getting ENOSPC/EQUOTA error?
> >>
> >> Suppose your "image" (i.e. total disk usage of lower) is 1GB
> >> and you want to allow user to touch all the files in the image and
> >> create 1GB of new files.
> >>
> >> If your only tool is project quota on upper then you need to set project
> >> quota hard limit to 2GB, but then user can create 2GB of new files and
> >> later when touching a lower file, will get EQUOTA on copy up.
> >>
> >> If you account lower uncovered files to overlay merged quota then
> >> you set the merged quota to 2GB and start with 50% used.
> >> - Copy up will not change used
> >> - Remove of lower will reduce used
> >> - You can never get EQUOTA from touching a file
> >
> > I get your point, I'd like to think it as "reservation" feature we can implement
> > in overlay for uncovered files, so that we can get rid of EQUOTA error during copy-up.
> > Even might get rid of ENOSPC error during copy-up when underlying filesystem supports
> > block reservation? Are there many people hope to have this kind of function?
> >
> 
> Not sure. I heard this requirement once, but I have a feeling people
> still don't know
> what they can get out of overlayfs, so they are used to getting along
> with what they
> have. I think now that docker supports project quotas with overlay2
> driver, people
> will start using project quota and sooner or later, they will start
> hitting EQUOTA on
> copy up. That's my prophecy anyway ;-)

I believe in the near future, most container users will experience this.
Indoe will be worse compare to space, not only fail on creating new file
but also on deleting old uncovered files because of plenty whiteout files. 
I remembered someone has already posted fix patch to reduce whiteout files,
so after that merged, we can consider block and inode in the same way.

Hi Zhang yi,

Is that possible to count space and inode of "covered"/"uncovered"/"upper"
via userspace command tool? I think those info will be useful/important reference
to admin to set reservation when mounting overlayfs. Then maybe I can add
some reservation logics in kernel side to avoid EQUOTA error as much as possible.  


Thanks,
Chengguang.
