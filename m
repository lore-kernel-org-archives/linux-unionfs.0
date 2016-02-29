From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v2 1/1] OverlayFS: Fix checking permissions during lookup.
Date: Mon, 29 Feb 2016 11:32:13 -0500
Message-ID: <20160229163213.GB3335@redhat.com>
References: <20160224135552.GB8422@zenon.in.qult.net>
 <20160226194143.GB13054@redhat.com>
 <419661456569602@web21g.yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <419661456569602@web21g.yandex.ru>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Nazarov Sergey <s-nazarov@yandex.ru>
Cc: Ignacy =?utf-8?B?R2F3xJlkemtp?= <ignacy.gawedzki@green-communications.fr>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Sat, Feb 27, 2016 at 01:40:02PM +0300, Nazarov Sergey wrote:
> 26.02.2016, 22:41, "Vivek Goyal" <vgoyal@redhat.com>:
> >
> > So what's the problem we are trying to solve. Why should we able to
> > override the DAC checks of lower layer if same directory in upper
> > is searchable for user but it is not searchable in lower layer.
> >
> 
> If I right, this is a one of the main feature of overlayfs - upper layer has priority over lower ones.
> Override AC checks necessary for lookup operation only. Lower layer files access AC checks
> remain, so this should not be a security problem.

So a directory which is not searchable by user in lower layer suddenly
becomes searchable once union is created. In fact there are two cases.
If upper layer directory does exist, then it is not searchable. If 
upper layer direcotry does exist with user having search permissions, then
lower layer directory should become searchable? May be, I don't know.

Thanks
Vivek
