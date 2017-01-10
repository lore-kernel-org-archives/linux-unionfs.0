From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH] ovl: do not ignore disk quota if current task is not privileged
Date: Tue, 10 Jan 2017 16:57:27 +0100
Message-ID: <CAJfpegsMM3k3-uEV4MefpC7QMyhJ+uR4tGnBzJockZa8P-5fZw@mail.gmail.com>
References: <148404760886.4400.14907571208759802396.stgit@buzz> <20170110144610.GC23108@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20170110144610.GC23108@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Tue, Jan 10, 2017 at 3:46 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Tue, Jan 10, 2017 at 02:26:48PM +0300, Konstantin Khlebnikov wrote:
>> If overlay was mounted by root then quota set for upper layer does not work
>> because overlay now always use mounter's credentials for operations.
>>
>> This patch adds second copy of credentials without CAP_SYS_RESOURCE and
>> use it if current task doesn't have this capability in mounter's user-ns.
>> This affects creation new files, whiteouts, and copy-up operations.
>>
>> Now quota limits are ignored only if both mounter and current task have
>> capability CAP_SYS_RESOURCE in root user namespace.
>
> This makes sense to me. I too would like quota to take effect for
> containers on overlay.

At first sight I hated this patch.  It breaks the nice concept that
underlying filesystems are just storage for the overlay and don't care
about caller's privileges (as a block device wouldn't care about
caller's privileges when allocating space).

However I don't see a good way around this, so...

Looks like this also has effect on reserving space in ext4, not sure
what that entails.

Thanks,
Miklos
