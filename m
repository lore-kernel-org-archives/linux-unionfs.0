Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxge7XzeJPDSdpQYEHH7iQwJD0-t78gHBbKtMUsO0dQrgw@mail.gmail.com>
References: <20171117054919.712-1-yi.zhang@huawei.com> <CAOQ4uxgCN-ZdLsZQmYYW-PyJLB4WWsr9A8gqOtcSC6S9Uj8qZA@mail.gmail.com>
 <8d55fcce-ebbf-4779-87de-8406fe475073@huawei.com> <CAOQ4uxge7XzeJPDSdpQYEHH7iQwJD0-t78gHBbKtMUsO0dQrgw@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 7 Mar 2018 13:20:42 +0200
Message-ID: <CAOQ4uxjbgQrg8MX0smdgYrV8_i3086ND_4d+Wpmcg+4G9RqY3Q@mail.gmail.com>
Subject: Re: [fsck.overlay RFC PATCH] overlay: add fsck utility
Content-Type: text/plain; charset="UTF-8"
To: yangerkun <yangerkun@huawei.com>
Cc: "zhangyi (F)" <yi.zhang@huawei.com>, overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Miao Xie <miaoxie@huawei.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Mar 7, 2018 at 1:14 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Wed, Mar 7, 2018 at 11:25 AM, yangerkun <yangerkun@huawei.com> wrote:
>>
>>
>> On 11/18/2017 1:13 AM, Amir Goldstein wrote:
>>>
>>> [adding fstests in CC with full patch inline to collect wisdom from
>>> other fs developers]
>>>
>>> On Fri, Nov 17, 2017 at 7:49 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
>>>>
>>>> Hi,
>>
>> [...]
>>>>
>>>>
>>>> Todo
>>>> ====
>>>>
>>>> 1. Overlay filesystem mounted check. Prevent fscking when overlay is
>>>> online. Now, We cannot distinguish mounted directories if overlayfs was
>>>> mounted with relative path.
>>>
>>>
>>> This should be handled by kernel.
>>> We now already grab an advisory exclusive I_OVL_INUSE lock on both
>>> upperdir and workdir.
>>> fsck.overlay can try to open upperdir/workdir with O_EXCL|O_DIRECTORY
>>> and kernel should fail this open if overlayfs is holding the  I_OVL_INUSE.
>>> Read the man page section on O_EXCL and block device. This is how
>>> e2fsck and friends get exclusive access w.r.t mount.
>>>
>>
>> In fsck.overlay, lower layer file/dir may be modified with there is not
>> I_OVL_INUSE in lower layer, but we cannot check does lower layer mounted
>> with I_OVL_INUSE.
>>
>
> Can you list the possible modifications the fsck.overlay can do on lower layer?
> What exactly are we trying to protect from?
>

Also, if we follow my suggestion above for upperdir/workdir
fsck.overlay may still
try to aquire I_OVL_INUSE on lowerdir with O_EXCL|O_DIRECTORY and kernel
can test I_OVL_INUSE flag on lowerdir without trying to set it on mount.

>> Maybe we need adopt another way? How about store pwd in ofs.config when we
>> mount the overlay.
>>
>
> I don't understand what that means.
>
> Instead of relying on the partial information available in /proc/<pid>/mountinfo
> we can export more interesting information from kernel per overlayfs mount,
> see for example the information available at /proc/fs/ext4/<blockdev>/
>
> For example, we can expose "layers" information, including the file handle of
> all layers root dir, so fsck.overlay can figure out if any upper/lower
> dir are in-use
> without needing to resolve paths.
>
> There is probably other interesting information from ofs.config that can
> be exposed this way.
>
> Instead of <blockdev> (in the ext4 case) the key would have to be the overlayfs
> anonymous dev, which can be read by stat(2) on any overlay directory.
>
> Thanks,
> Amir.
