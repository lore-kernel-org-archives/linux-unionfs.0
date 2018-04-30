Return-Path: <vgoyal@redhat.com>
Date: Mon, 30 Apr 2018 09:06:50 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v14 12/31] ovl: Add an helper to get real data dentry
Message-ID: <20180430130650.GA7960@redhat.com>
References: <20180426191013.13219-1-vgoyal@redhat.com>
 <20180426191013.13219-13-vgoyal@redhat.com>
 <CAOQ4uxhgyVYQKXKXqLffukHnTFqdoCRAHx=c4xr-vi_RANSs9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhgyVYQKXKXqLffukHnTFqdoCRAHx=c4xr-vi_RANSs9g@mail.gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Apr 26, 2018 at 01:33:50PM -0700, Amir Goldstein wrote:

[..]
> > +/* Return real dentry which contains data. Skip metacopy dentries */
> > +struct dentry *ovl_dentry_real_data(struct dentry *dentry)
> 
> The name real_data is a bit inconsistent with _upperdata and
> _lowerdata. Don't you think _realdata would be more coherent.

_realdata sounds good. I was wondering about that too. Will change.

Vivek
