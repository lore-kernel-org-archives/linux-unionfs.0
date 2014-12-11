From: hujianyang <hujianyang@huawei.com>
Subject: Re: [PATCH RFC] ovl: discard independent cursor in readdir()
Date: Thu, 11 Dec 2014 10:04:27 +0800
Message-ID: <5488FBAB.8050109@huawei.com>
References: <5488222C.6080108@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([119.145.14.64]:11417 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932937AbaLKCEm (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Wed, 10 Dec 2014 21:04:42 -0500
In-Reply-To: <5488222C.6080108@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

On 2014/12/10 18:36, hujianyang wrote:
> Since the ovl_dir_cache is stable during a directory reading, the cursor
> of struct ovl_dir_file don't need to be an independent entry in the list
> of a merged directory.
> 
> This patch changes *cursor* to a pointer which points to the entry in the
> ovl_dir_cache. After this, we don't need to check *is_cursor* either.
> 

Sorry, there is something wrong with this patch. Please, drop it~!


