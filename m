From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: Re: [PATCH] ovl: do not ignore disk quota if current task is not
 privileged
Date: Tue, 10 Jan 2017 19:34:59 +0300
Message-ID: <859c4d99-dc1d-312b-6c60-23749cea4495@yandex-team.ru>
References: <148404760886.4400.14907571208759802396.stgit@buzz>
 <20170110144610.GC23108@redhat.com>
 <CAJfpegsMM3k3-uEV4MefpC7QMyhJ+uR4tGnBzJockZa8P-5fZw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAJfpegsMM3k3-uEV4MefpC7QMyhJ+uR4tGnBzJockZa8P-5fZw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>, Vivek Goyal <vgoyal@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On 10.01.2017 18:57, Miklos Szeredi wrote:
> On Tue, Jan 10, 2017 at 3:46 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> On Tue, Jan 10, 2017 at 02:26:48PM +0300, Konstantin Khlebnikov wrote:
>>> If overlay was mounted by root then quota set for upper layer does not work
>>> because overlay now always use mounter's credentials for operations.
>>>
>>> This patch adds second copy of credentials without CAP_SYS_RESOURCE and
>>> use it if current task doesn't have this capability in mounter's user-ns.
>>> This affects creation new files, whiteouts, and copy-up operations.
>>>
>>> Now quota limits are ignored only if both mounter and current task have
>>> capability CAP_SYS_RESOURCE in root user namespace.
>>
>> This makes sense to me. I too would like quota to take effect for
>> containers on overlay.
>
> At first sight I hated this patch.  It breaks the nice concept that
> underlying filesystems are just storage for the overlay and don't care
> about caller's privileges (as a block device wouldn't care about
> caller's privileges when allocating space).
>
> However I don't see a good way around this, so...

Another solution: just always drop CAP_SYS_RESOURCE from capabilities.

> Looks like this also has effect on reserving space in ext4, not sure
> what that entails.

Yes, CAP_SYS_RESOURCE allows to use reserved space and inodes.

-- 
Konstantin
