Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <fce631b9-7c69-f308-1215-52bfe5b6eb59@huawei.com>
References: <c976a238-a45c-c385-61db-e94844e3c01a@huawei.com>
 <CAOQ4uxiMMWjVxWDq380qaun9kXMP4pFNxfvk=HjwH1joABKB-A@mail.gmail.com> <fce631b9-7c69-f308-1215-52bfe5b6eb59@huawei.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 28 May 2018 18:46:44 +0300
Message-ID: <CAOQ4uxh8yp6Y80-CDYQe2-6RP7_DT5=GHoAnO2aM-=jO-qORSw@mail.gmail.com>
Subject: Re: Question about CAP_SYS_RESOURCES in overlayfs
Content-Type: text/plain; charset="UTF-8"
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Vivek Goyal <vgoyal@redhat.com>, zengweilin@huawei.com, Miao Xie <miaoxie@huawei.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Mon, May 28, 2018 at 4:54 PM, zhangyi (F) <yi.zhang@huawei.com> wrote:
> On 2018/5/28 17:23, Amir Goldstein wrote:
>> On Mon, May 28, 2018 at 11:13 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
>>> Hi All,
>>>
>>> Now, we have a problem when we use "docker + overlayfs + ext4 project quota".
>>> The project quota limit were set for each container's overlay dirs on one
>>> basic ext4 filesystem, but part of them are privilege containers which have
>>> CAP_SYS_RESOURCE and may want to exceed it's quota limit to use the reserved
>>> space. But we can't because overlayfs drops CAP_SYS_RESOURCES from saved
>>> credentials and don't allow to use the reserved space in basic ext4 filesystem
>>> even it is a privileged process.
>>>
>>
>> What makes you say that a "privilege container" would want to exceed the quota
>> set to that container by the container runtime admin?
>> The essence of "containers" (even privileged) is to "contain" resources.
>>
>> IOW, you are claiming there is a use case, where container admin wishes
>> to limit the quota for all container changes from non-privileged processes
>> and not limit the quota for privileged processes. Can you give an example
>> of where that makes sense?
>>
>
> Hi Amir, thanks for your answer,
>
> From the use case's point of view:
>
> You are right, it seems that this use case is not very reasonable, it's more
> reasonable to disable quota limit for privileged container or give a suitable
> limit value.
>

So the discussion about overlayfs change can end here.
We only need to make changes to cater reasonable use cases,
especially if those changes would complicate the code.

>>> I notice that this point have been already discussed in (51f8f3c4e "ovl: drop
>>> CAP_SYS_RESOURCE from saved mounter's credentials") [1] and it works well
>>> at that time. But I still want to ask again is it better to inherit caller's
>>> CAP_SYS_RESOURCES let privileged to use reserved space (keep basic filesystem's
>>> ability) now ? If so, I can post a patch to cover this; If not, we should avoid
>>> setting quota limit for privilege containers.
>>>
>>> [1] https://patchwork.kernel.org/patch/9508297/
>>>
>>
>> Please consider the fact that "docker + overlayfs + xfs project quota" enforces
>> quota for non-root userns privileged processes, regardless of CAP_SYS_RESOURCE,
>> so your suggested change will diverge behavior of "docker + overlayfs + xfs
>> project quota" and "docker + overlayfs + ext4 project quota". Am I wrong?
>> That doesn't sound like a good idea, does it?
>>
>
> From the filesystem's point of view:
>
> I am not familiar with xfs. IIUC, xfs project quota does not check
> CAP_SYS_RESOURCES at all, so the root cause of this divergence
> between "docker + overlayfs + xfs prjquota" and "docker + overlayfs +
> prjquota" is the different policies of how to deal with the
> CAP_SYS_RESOURCES between these two filesystems, so one reason of
> we drop CAP_SYS_RESOURCES in overlayfs is to avoid this difference?
>

Not really. The reason was to prevent non privileged user to exceed quota,
but I did use the xfs behavior as one of the argument in favor of keeping the
original patch simple (i.e. disregard user's CAP_SYS_RESOURCES).

> One item of CAP_SYS_RESOURCE in capabilities(7) say: "override disk quota
> limits", why xfs don't check it? I notice that any other filesystems which
> use common quota (fs/quota) support CAP_SYS_RESOURCES entirely. Although
> xfs don't use fs/quota, is xfs better to support CAP_SYS_RESOURCES either?
>

I don't know why. Possibly because xfs quotas came from IRIX and capabilities
are a Linux specific API. I am not sure that xfs will not be welcoming
a change to
support CAP_SYS_RESOURCES, but you are welcome to try.
You better come up with an actual use case if you propose a change like this.

> So if xfs can support CAP_SYS_RESOURCES, overlayfs follow caller's
> capability can be a better choice (according to capabilities(7)),
> dose it?
>

We don't need to change the code to match man page.
We can also change man page to match the code, but the
best is if we change both to match what users need.

The docker project quota use case IMO needs the existing behavior.
There may be other use cases that need a different behavior.
If such actual use cases are presented, we can consider them and maybe
offer a configuration option to dictate the behavior of overlayfs.

Thanks,
Amir.
