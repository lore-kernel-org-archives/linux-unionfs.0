Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <c976a238-a45c-c385-61db-e94844e3c01a@huawei.com>
References: <c976a238-a45c-c385-61db-e94844e3c01a@huawei.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 28 May 2018 12:23:39 +0300
Message-ID: <CAOQ4uxiMMWjVxWDq380qaun9kXMP4pFNxfvk=HjwH1joABKB-A@mail.gmail.com>
Subject: Re: Question about CAP_SYS_RESOURCES in overlayfs
Content-Type: text/plain; charset="UTF-8"
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Vivek Goyal <vgoyal@redhat.com>, zengweilin@huawei.com, Miao Xie <miaoxie@huawei.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Mon, May 28, 2018 at 11:13 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
> Hi All,
>
> Now, we have a problem when we use "docker + overlayfs + ext4 project quota".
> The project quota limit were set for each container's overlay dirs on one
> basic ext4 filesystem, but part of them are privilege containers which have
> CAP_SYS_RESOURCE and may want to exceed it's quota limit to use the reserved
> space. But we can't because overlayfs drops CAP_SYS_RESOURCES from saved
> credentials and don't allow to use the reserved space in basic ext4 filesystem
> even it is a privileged process.
>

What makes you say that a "privilege container" would want to exceed the quota
set to that container by the container runtime admin?
The essence of "containers" (even privileged) is to "contain" resources.

IOW, you are claiming there is a use case, where container admin wishes
to limit the quota for all container changes from non-privileged processes
and not limit the quota for privileged processes. Can you give an example
of where that makes sense?

> I notice that this point have been already discussed in (51f8f3c4e "ovl: drop
> CAP_SYS_RESOURCE from saved mounter's credentials") [1] and it works well
> at that time. But I still want to ask again is it better to inherit caller's
> CAP_SYS_RESOURCES let privileged to use reserved space (keep basic filesystem's
> ability) now ? If so, I can post a patch to cover this; If not, we should avoid
> setting quota limit for privilege containers.
>
> [1] https://patchwork.kernel.org/patch/9508297/
>

Please consider the fact that "docker + overlayfs + xfs project quota" enforces
quota for non-root userns privileged processes, regardless of CAP_SYS_RESOURCE,
so your suggested change will diverge behavior of "docker + overlayfs + xfs
project quota" and "docker + overlayfs + ext4 project quota". Am I wrong?
That doesn't sound like a good idea, does it?

Thanks,
Amir.
