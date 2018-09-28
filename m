From: Jan Harkes <jaharkes@cs.cmu.edu>
Subject: Re: [PATCH] fs: fix access beyond unterminated strings in prints
Date: Fri, 28 Sep 2018 15:15:58 -0400
Message-ID: <20180928191558.5xzf73soxogjm4ba@cs.cmu.edu>
References: <20180928180048.14259-1-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180928180048.14259-1-amir73il@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Jeff Layton <jlayton@kernel.org>, Mark Fasheh <mark@fasheh.com>
List-Id: linux-unionfs@vger.kernel.org

On Fri, Sep 28, 2018 at 09:00:48PM +0300, Amir Goldstein wrote:
> I chose not to split the patches per fs in the hope that maintainers
> would quickly ack the patch and ask you to carry it for them.

Ack for Coda. I actually have a patch queued somewhere that dropped
printing the name and only prints the length, but this works too.

Jan
