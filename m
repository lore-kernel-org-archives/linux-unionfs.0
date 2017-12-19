From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v3] ovl: Check link ability between upperdir and workdir
Date: Tue, 19 Dec 2017 08:48:49 -0500
Message-ID: <20171219134849.GA2737@redhat.com>
References: <1513601748-57439-1-git-send-email-cgxu519@icloud.com>
 <20171218160251.GA7474@redhat.com>
 <C6350633-4F41-424F-B936-606CDAF2A8DF@icloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51750 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1763009AbdLSNsu (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 19 Dec 2017 08:48:50 -0500
Content-Disposition: inline
In-Reply-To: <C6350633-4F41-424F-B936-606CDAF2A8DF@icloud.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Chengguang Xu <cgxu519@icloud.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, amir73il@gmail.com, linux-unionfs@vger.kernel.org

On Tue, Dec 19, 2017 at 09:49:28AM +0800, Chengguang Xu wrote:
> > 
> > 在 2017年12月19日，上午12:02，Vivek Goyal <vgoyal@redhat.com> 写道：
> > 
> > On Mon, Dec 18, 2017 at 08:55:48PM +0800, Chengguang Xu wrote:
> >> Inspired by encountering unexpected write error when
> >> upperdir and workdir having different project ids.
> > 
> > Can you please make this problem descrition little better. By
> > these two lines I really don't understand what's the problem
> > you are trying to solve. All I understood was that upperdir
> > and workdir had different project id. But not sure what
> > problem it led to and why.
> > 
> > In fact your first patch changelong was little better. It
> > atleast said that you encounter "-EXDEV". So is it rename
> > which fails. So rename is not allowed between two directories
> > having different project ids?
> > 
> 
> The background is
> I encountered an unexpected write error with error code -EXDEV in
> my environment which didn’t break any rules in overlayfs kernel
> document.
> 
> So I did some investigations and found when upperdir and workdir
> having different project quotas then rename/link operations between
> those directories would be fail with -EXDEV because project quota
> asks files in it strictly inherit project id with it’s own. This will
> make write fail during copy-up process.
> 
> I wrote first patch to check this condition, but that check seems not
> sufficient to detect write error, so after discussion with Amir,
> we decided to check link ability between upperdir and workdir, it is
> what copy-up actually doing when modifying files in lowerdirs, and also
> I decided to only print a warning message instead of directly mounting
> on read-only mode in case there is a special use case just read and do not 
> modify anything in lowerdirs.

Ok, thanks for the explanation. I really wish that some of it makes to
changelog so that somebody reading it later finds it much easier to
understand.

BTW, just curious, when upper supports O_TMPFILE, do we have to create
tmpfile in workdir/. Can we create it in upper/ and then link in
appropriate destination directory.

Amir, is there a fundamental requirement about why tmpfile creation has
to be in workdir.

Vivek
