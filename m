From: hujianyang <hujianyang@huawei.com>
Subject: Cursor in readdir
Date: Sat, 29 Nov 2014 18:11:40 +0800
Message-ID: <54799BDC.5030201@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([119.145.14.66]:5069 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbaK2KMI (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Sat, 29 Nov 2014 05:12:08 -0500
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

Hi Miklos,

Sorry for disturb you. I'm confused with *cursor* in struct
ovl_dir_file. I know this struct ovl_cache_entry *cursor* is
presented to indicate current pos when performing readdir at
a MERGE type directory.

Why this additional entry is needed? Can't we use a pointer
to record which entry is read or is ready for reading? After
finish reading lower and upper directories, entries in struct
ovl_dir_cache is stabilized. Changing of directories will
cause the later .readdir() to create a new ovl_dir_cache but
the old cache will not be released until all the holders of
it call .release().

So I think a pointer points to an entry in the entry list of
ovl_dir_cache is enough to each process sharing the access
of the same cache. We don't need to keep and move an special
entry, *cursor*. That's my thought.

I've considered a lot and googled some key words but found
nothing. Did I miss something important?

It will be fine if you'd like to explain the requirement of
*cursor* in readdir. Thanks a lot~!


Hu


