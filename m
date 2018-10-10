Return-Path: <zohar@linux.ibm.com>
Subject: Re: [PATCH v2] Open a new file instance if no read permissions
From: Mimi Zohar <zohar@linux.ibm.com>
Date: Wed, 10 Oct 2018 15:04:42 -0400
In-Reply-To: <20181009151233.lxgm5c73epofi6r3@merlin>
References: <20181009151233.lxgm5c73epofi6r3@merlin>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Message-Id: <1539198282.3585.6.camel@linux.ibm.com>
To: Goldwyn Rodrigues <rgoldwyn@suse.de>, James Morris <jmorris@namei.org>
Cc: linux-integrity@vger.kernel.org, linux-unionfs@vger.kernel.org, iforster@suse.de, fvogt@suse.de, miklos@szeredi.hu
List-ID: <linux-unionfs@vger.kernel.org>

Hi Goldwyn,

On Tue, 2018-10-09 at 10:12 -0500, Goldwyn Rodrigues wrote:
> Open a new file instance as opposed to changing file->f_mode when
> the file is not readable. This is done to accomodate
> overlayfs stacked file operations change. The real struct file is hidden
> behind the overlays struct file. So, any file->f_mode manipulations are
> not reflected on the real struct file. Open the file again in read mode
> if original file cannot be read, read and calculate the hash.
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>

Thanks!  I'm waiting for it to hit linux-next, before sending James
the linux-integrity pull request.

Mimi
