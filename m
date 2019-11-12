Return-Path: <jiufei.xue@linux.alibaba.com>
From: Jiufei Xue <jiufei.xue@linux.alibaba.com>
Subject: [Regression] performance regression since v4.19
Message-ID: <1086cadc-53c3-effd-5ba3-797a015944b5@linux.alibaba.com>
Date: Tue, 12 Nov 2019 15:53:43 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Joseph Qi <joseph.qi@linux.alibaba.com>
List-ID: <linux-unionfs@vger.kernel.org>

Hi Miklos,

A performance regression is observed since linux v4.19 when we do aio
test using fio with iodepth 128 on overlayfs. And we found that queue
depth of the device is always 1 which is unexpected. 

After investigation, it is found that commit 16914e6fc7
(“ovl: add ovl_read_iter()”) and commit 2a92e07edc
(“ovl: add ovl_write_iter()”) use do_iter_readv_writev() to submit
requests to real filesystem. Async IOs are converted to sync IOs here
and cause performance regression.

I wondered that is this a design flaw or supposed to be.

Thanks a lot,
Jiufei
