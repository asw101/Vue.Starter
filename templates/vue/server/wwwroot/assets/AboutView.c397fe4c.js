import{d as m,o as a,c as o,w as s,T as u,a as r,u as l,_ as n}from"./index.56f2a20c.js";const c=m("dummy",{state(){return{docs:[],dummy:{}}},actions:{getDummies(e=3,i="540x460"){for(let t=1;t<=e;t++)this.docs.push({title:"Lorem Ipsum",html:"Velit tempor ea laboris velit anim ad exercitation do qui veniam. In anim laborum qui duis ullamco sit reprehenderit adipisicing ullamco reprehenderit dolore dolore. Duis veniam ullamco commodo reprehenderit laboris sit. Et incididunt ea magna excepteur ullamco dolore culpa in. Deserunt minim voluptate culpa Lorem nulla in velit.",image:`https://dummyimage.com/${i}`,link:"#"})},getDummy(e="540x460"){this.getDummies(1,e),this.dummy=this.docs[0]}}}),_={__name:"AboutView",setup(e){const{dummy:i,getDummy:t}=c();return t(),(d,p)=>(a(),o(u,{class:"mt-12"},{default:s(()=>[r(n,{doc:l(i)},null,8,["doc"])]),_:1}))}};export{_ as default};