Return-Path: <cgxu519@gmx.com>
MIME-Version: 1.0
Message-ID: <trinity-c4776725-d637-418a-a2f1-b317c3ed3144-1520475704072@3c-app-mailcom-bs01>
From: "Chengguang Xu" <cgxu519@gmx.com>
Subject: Re: "quota-df" feature
Content-Type: text/plain; charset=UTF-8
Date: Thu, 8 Mar 2018 03:21:44 +0100
In-Reply-To: <CAOQ4uxji73iSXeS-keVrH264iXZs6-4XkGS2rQYU2AsjT6JikQ@mail.gmail.com>
References: <trinity-cf8cc163-74dd-4b20-8372-28cbce5bfa47-1520427171633@3c-app-mailcom-bs03>
 <CAOQ4uxji73iSXeS-keVrH264iXZs6-4XkGS2rQYU2AsjT6JikQ@mail.gmail.com>
Content-Transfer-Encoding: quoted-printable
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

> Sent: Wednesday, March 07, 2018 at 9:28 PM
> From: "Amir Goldstein" <amir73il@gmail=2Ecom>
> To: "Chengguang Xu" <cgxu519@gmx=2Ecom>
> Cc: overlayfs <linux-unionfs@vger=2Ekernel=2Eorg>, "Miklos Szeredi" <mik=
los@szeredi=2Ehu>
> Subject: Re: "quota-df" feature
>
> On Wed, Mar 7, 2018 at 2:52 PM, Chengguang Xu <cgxu519@gmx=2Ecom> wrote:
> > Hello folks,
> >
> > Recently I'm trying to implement a feature on overlayfs for our users=
=2E
> > I'd like to call it "quota-df" which means when calling statfs(2),
> > override/update some fields(e=2Eg=2E, total/used/avail of both block/i=
node counts=EF=BC=89
> > using proper project quota information if the quota has already set to
> > underlying directories of overlayfs=2E
> >
>=20
> Do you mean project quota setting on underlying fs directories or
> something else?

Underlying fs directories, more accurately the directory include
upperdir && workdir=2E

>=20
> > This feature is probably useful for most of container users and there =
is
> > no serious side effect to the other parts=2E We can also provide a new
> > mount option to enable/disable the function according to different use=
 cases=2E
> >
> > Although I'm still working on it but I'll post the RFC patch here for =
review
> > in recent days and hope to get some feedback from you=2E Any kind of s=
uggestions
> > are welcomed=2E
> >
>=20
> I was asked about quota accounting for the merged content of overalyfs,
> so quota would display a number resembling du -s on the overlay mount=2E
> This means that "covered" lower files are not accounted for in the merge=
=2E
> Is that what you aim to achieve? If not, would that also be an interesti=
ng case
> for you to explore?
> Basically, the index directory could be used to reconstruct the entire q=
uota
> information for upper and lower (and copied up) files if full indexing
> is enabled
> with nfs_export=3Don=2E

To be honest, our use case is standard docker container with overlayfs and
our requirement of quota-df is accurately counting usage/avail inside cont=
ainer=2E

Lowerdirs could be share with different overlayfs, so I'm not sure countin=
g
the contents of lowerdirs is proper behavior or not=2E If lowerdirs are de=
dicated
to one overlayfs then maybe setting same project id with upperdir can reso=
lve
"covered" problem that you mentioned above=2E Counting usage information w=
ithout
quota might be a hard work when having plenty of files=2E

I don't know exactly what will happen when combining index and nfs_export =
options,
I need to read and understand related code later=2E

>=20
> >
> > Here are some test examples share with you (based on ext4):
> >
> > 1) project quota enabled && without hard-limit
> >
> > $ df -h /mnt/test3 /mnt/test3/df/merged
> > Filesystem      Size  Used Avail Use% Mounted on
> > /dev/vdb3        99G  2=2E5G   91G   3% /mnt/test3
> > overlay          92G  201M   91G   1% /mnt/test3/df/merged
> >
> > $ df -hi /mnt/test3 /mnt/test3/df/merged
> > Filesystem     Inodes IUsed IFree IUse% Mounted on
> > /dev/vdb3        6=2E3M  2=2E4K  6=2E3M    1% /mnt/test3
> > overlay          6=2E3M     8  6=2E3M    1% /mnt/test3/df/merged
> >
> > 2) project quota enabled && with hard-limit
> >
> > $ df -h /mnt/test3 /mnt/test3/df/merged
> > Filesystem      Size  Used Avail Use% Mounted on
> > /dev/vdb3        99G  2=2E5G   91G   3% /mnt/test3
> > overlay         1=2E0G  201M  824M  20% /mnt/test3/df/merged
> >
> > $ df -hi /mnt/test3 /mnt/test3/df/merged
> > Filesystem     Inodes IUsed IFree IUse% Mounted on
> > /dev/vdb3        6=2E3M  2=2E4K  6=2E3M    1% /mnt/test3
> > overlay          1000     8   992    1% /mnt/test3/df/merged
> >
> >
>=20
> I can't follow from the example below what is the expected result and wh=
y
> if you add the quota setup commands that could be useful=2E

Underlying fs using ext4 and mkfs/mount with project quota option and
all needed directories(lowerdir, upperdir, workdir, merged) are set same
project quota=2E Current quota-df implementation only adjust the couting
information when having upperdir=2E

In case 1:
There is no hardlimit/softlimit, so the expected result as below=2E
Used:  The used count in project quota which set to the directory
       include upperdir && workdir=2E
Avail: The avail of underlying fs
Total: Used + Avail

#upperdir used 201M and /mnt/test3 used 2=2E5G

In case 2:
Project quota hardlimits are block count =3D 1G, inode count =3D 1000=2E
So the expected result as below=2E

Used:  The used count in project quota which set to the directory
       include upperdir && workdir=2E
Avail: (a)Hardlimit - Used or (b)The avail of underlying fs(when a > b)
Total: Used + Avail

Thanks,
Chengguang=2E
