Return-Path: <cgxu519@gmx.com>
From: cgxu519 <cgxu519@gmx.com>
Subject: fadvise in overlayfs
Message-ID: <ca0a6866-4f68-8066-2530-684c2ea36630@gmx.com>
Date: Sun, 25 Nov 2018 22:03:04 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
To: overlayfs <linux-unionfs@vger.kernel.org>
Cc: Amir Goldstein <amir73il@gmail.com>, miklos@szeredi.hu
List-ID: <linux-unionfs@vger.kernel.org>

Hello,


I noticed overlayfs will possibly do fadvise operation on upper or lower 
files.

So I'm little curious when doing fadvise with flag 'POSIX_FADV_DONTNEED'

to evict page cache on lower file which is shared with other overlayfs 
instances,

isn't there any unexpected side effect?

I have not done very detail test for exact result for it but when

I run vmtouch(to evict page cache) and append write(to copy-up) in 
different instances,

sometimes, copy-up seems failed with EIO.

If above is correct, I would like to propose to do fadvise only for 
upper layer.

What do you think for this?


Thanks,

Chengguang
