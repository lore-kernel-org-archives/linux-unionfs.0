Return-Path: <michael.weiss@aisec.fraunhofer.de>
Subject: Re: [PATCH] ovl: Introduce mount option hide_paths
References: <20190410100150.13939-1-michael.weiss@aisec.fraunhofer.de>
 <20190411201131.GA23000@redhat.com>
 <58e6d0d1-207b-d877-e91a-3336aa512c72@aisec.fraunhofer.de>
 <CAOQ4uxit=0_iTxetdhGEJcimpoAs_tTpZM2ACTnC6QoiOPUc-A@mail.gmail.com>
From: =?UTF-8?Q?Michael_Wei=c3=9f?= <michael.weiss@aisec.fraunhofer.de>
Message-ID: <1a7f5f7e-d210-4419-fd46-ff43d213b7c9@aisec.fraunhofer.de>
Date: Fri, 12 Apr 2019 15:48:49 +0200
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxit=0_iTxetdhGEJcimpoAs_tTpZM2ACTnC6QoiOPUc-A@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Return-Path: michael.weiss@aisec.fraunhofer.de
To: Amir Goldstein <amir73il@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

Hi Amir,

yeah I see, that was too easy.
Thanks for that hint.

Cheers,
Michael


On 12.04.19 13:25, Amir Goldstein wrote:
> On Fri, Apr 12, 2019 at 10:55 AM Michael Weiß
> <michael.weiss@aisec.fraunhofer.de> wrote:
>> Hi Vivek,
>>
>> yes it is, because the path names are in the options and not
>> in the mount source. I only know overlayfs as kernel filesystem
>> which uses the options for source pathes, due to obvious reasons.
>>
>> On a bind mount the source block device on which the directory
>> is located will be shown as source, thus there is no information leak
>> in the mount namespace / chroot there.
>>
>> Short example:
>>
>> bind mount:
>>
>> host:
>> mount --bind /mnt/test-rootns/ /var/lib/schroot/mount/stable-a73e0370-da3c-4325-aa4c-2585febb65d5/root/test/
>>
>> /dev/mapper/system-root on /var/lib/schroot/mount/stable-a73e0370-da3c-4325-aa4c-2585febb65d5/root/test type ext4 (rw,noatime,errors=remount-ro,user_xattr,barrier=1,data=ordered)
>>
>> chroot:
>>
>> /dev/mapper/system-root on /root/test type ext4 (rw,noatime,errors=remount-ro,user_xattr,barrier=1,data=ordered)
>>
>> overlayfs:
>>
>> host:
>>
>> overlay on /var/lib/docker/overlay2/9c428ab5204f10fad81dbd6ea21bddad7c3173f1811651c1b37d93f02e5dbb39/merged type overlay (rw,relatime,lowerdir=/var/lib/docker/overlay2/l/MXNJRWHBTT3FY7ZLXSZOXZHEDX:/var/lib/docker/overlay2/l/Q5R45CZKDNRTTYJ4RSP6OWYRT2,upperdir=/var/lib/docker/overlay2/9c428ab5204f10fad81dbd6ea21bddad7c3173f1811651c1b37d93f02e5dbb39/diff,workdir=/var/lib/docker/overlay2/9c428ab5204f10fad81dbd6ea21bddad7c3173f1811651c1b37d93f02e5dbb39/work)
>>
>> chroot:
>>
>> overlay on / type overlay (rw,relatime,lowerdir=/var/lib/docker/overlay2/l/MXNJRWHBTT3FY7ZLXSZOXZHEDX:/var/lib/docker/overlay2/l/Q5R45CZKDNRTTYJ4RSP6OWYRT2,upperdir=/var/lib/docker/overlay2/9c428ab5204f10fad81dbd6ea21bddad7c3173f1811651c1b37d93f02e5dbb39/diff,workdir=/var/lib/docker/overlay2/9c428ab5204f10fad81dbd6ea21bddad7c3173f1811651c1b37d93f02e5dbb39/work)
>>
>>
> You know, these options are just strings.
> It's not a problem to use any strings you like using symlink to avoid
> leaking paths.
> Its exactly the same method that docker uses to shorten the mount
> option args length,
> for example:
>
> cd var/lib/docker/overlay2/9c428ab5204f10fad81dbd6ea21bddad7c3173f1811651c1b37d93f02e5dbb39/
> ln -s ../l/MXNJRWHBTT3FY7ZLXSZOXZHEDX l0
> ln -s ../l/Q5R45CZKDNRTTYJ4RSP6OWYRT2 l1
> mount -t overlay overlay merged/ -olowerdir=l0:l1,upperdir=diff,workdir=work
>
> And that's it.
> I wonder why docker is not that to shorten the argument list instead
> of the l/XXX symlinks
>
> Thanks,
> Amir.
