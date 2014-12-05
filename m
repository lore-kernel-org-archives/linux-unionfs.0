From: hujianyang <hujianyang@huawei.com>
Subject: Re: Cursor in readdir
Date: Fri, 5 Dec 2014 17:47:05 +0800
Message-ID: <54817F19.4010609@huawei.com>
References: <54799BDC.5030201@huawei.com> <CAJfpegt5vmDG-8=CoD1-FbHoMQFmFKvPELoU6OiUULoffkb-vQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:25930 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893AbaLEJrU (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Fri, 5 Dec 2014 04:47:20 -0500
In-Reply-To: <CAJfpegt5vmDG-8=CoD1-FbHoMQFmFKvPELoU6OiUULoffkb-vQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

On 2014/12/1 23:26, Miklos Szeredi wrote:
> On Sat, Nov 29, 2014 at 11:11 AM, hujianyang <hujianyang@huawei.com> wrote:
>> Hi Miklos,
>>
>> Sorry for disturb you. I'm confused with *cursor* in struct
>> ovl_dir_file. I know this struct ovl_cache_entry *cursor* is
>> presented to indicate current pos when performing readdir at
>> a MERGE type directory.
>>
>> Why this additional entry is needed? Can't we use a pointer
>> to record which entry is read or is ready for reading? After
>> finish reading lower and upper directories, entries in struct
>> ovl_dir_cache is stabilized. Changing of directories will
>> cause the later .readdir() to create a new ovl_dir_cache but
>> the old cache will not be released until all the holders of
>> it call .release().
>>
>> So I think a pointer points to an entry in the entry list of
>> ovl_dir_cache is enough to each process sharing the access
>> of the same cache. We don't need to keep and move an special
>> entry, *cursor*. That's my thought.
> 
> Cursors are safe against removal of current entry.   However, we don't
> do that here, AFAICS, so I think you are correct in that the cursor is
> not actually needed here.
> 

Thanks~!

Do you think it's valuable to discard the using of *cursor* and
use a pointer instead? Or maybe we will enable some remove
operations for ovl_dir_cache in the future so we should keep
this mechanism.

What's your opinion? I'd like to change this part and see if
the usage of a pointer could speed up .readdir() on a merged
directory.

Cheers,

Hu


