From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 16/28] ovl: Do not expose metacopy only dentry from d_real()
Date: Thu, 31 May 2018 07:30:06 +0300
Message-ID: <CAOQ4uxjNzc+=AyfhYBAi_-NkMss7HS3hTRBjYUgkmuFdB6-sRA@mail.gmail.com>
References: <20180529144612.16675-1-mszeredi@redhat.com> <20180529144612.16675-17-mszeredi@redhat.com>
 <20180530210556.GD2717@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180530210556.GD2717@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Miklos Szeredi <mszeredi@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Thu, May 31, 2018 at 12:05 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Tue, May 29, 2018 at 04:46:00PM +0200, Miklos Szeredi wrote:
>> From: Vivek Goyal <vgoyal@redhat.com>
>>
>> Metacopy dentry/inode is internal to overlay and is never exposed outside
>> of it.  Exception is metacopy upper file used for fsync().  Modify d_real()
>> to look for dentries/inode which have data, but also allow matching upper
>> inode without data for the fsync case.
>>
>
> Hi Miklos,
>
> I am not able to see how in fsync() path d_real() gets called. If we
> decide to do fsync() on upper metacopy, then opening upper will not
> go through d_real(). And we never issue fsync() on lower.
>
> So I am scratching my head while trying to understand the d_real() and
> fsync() connection.
>

fsync() exposes real meta inode to vfs, so file_dentry() needs to
be able to find the real meta upper dentry.

Thanks,
Amir.
